using System;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace WinFormsApp1
{
    public partial class Form1 : Form
    {
        private string csvFilePath = "";
        private DataTable dataTable;
        private Random random = new Random();

        public Form1()
        {
            InitializeComponent();

            // Initialize filters
            comboBox1.Items.AddRange(new object[] { "Europe", "North America", "Pacific" });
            comboBox2.Items.AddRange(new object[] { "Australia", "Canada", "Central", "France", "Germany", "Northeast", "Northwest", "Southeast", "Southwest", "United Kingdom"});
            comboBox3.Items.AddRange(new object[] { "Accessories", "Bikes", "Clothing", "Components" });

            // Event handlers 
            comboBox1.SelectedIndexChanged += FilterChanged;
            comboBox2.SelectedIndexChanged += FilterChanged;
            comboBox3.SelectedIndexChanged += FilterChanged;

            // Initialize DataTable
            dataTable = new DataTable();
            table.DataSource = dataTable;

            // Wire up event handlers
            addSale.Click += AddButton_Click;

            // Auto-load CSV file if it exists
            string csvPath = Path.Combine(Application.StartupPath, "datamart.csv");
            if (File.Exists(csvPath))
            {
                csvFilePath = csvPath;
                LoadCSVData(csvFilePath);
            }

            // Hide columns
            string[] visibleColumns = {
                "OnlineOrderFlag", "Product", "ProductCategory", "ProductSubCategory",
                "Region", "SalesOrderID", "ShipDate", "Territory", "TotalDue"
            };

            foreach (DataGridViewColumn col in table.Columns)
            {
                col.Visible = visibleColumns.Contains(col.Name);
            }
        }

        // Add new sale
        private void AddButton_Click(object sender, EventArgs e)
        {
            if (dataTable.Columns.Count == 0 || dataTable.Rows.Count == 0)
            {
                MessageBox.Show("Please load a CSV file with data first.", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }

            try
            {
                // Find the maximum SalesOrderID (if it exists)
                int maxSalesOrderID = 0;
                bool hasSalesOrderID = dataTable.Columns.Contains("SalesOrderID");
                bool hasSalesOrderNumber = dataTable.Columns.Contains("SalesOrderNumber");
                bool hasShipDate = dataTable.Columns.Contains("ShipDate");

                if (hasSalesOrderID)
                {
                    foreach (DataRow row in dataTable.Rows)
                    {
                        if (int.TryParse(row["SalesOrderID"].ToString(), out int orderID))
                        {
                            maxSalesOrderID = Math.Max(maxSalesOrderID, orderID);
                        }
                    }
                }

                // Select a random existing row
                int randomRowIndex = random.Next(0, dataTable.Rows.Count);
                DataRow randomRow = dataTable.Rows[randomRowIndex];

                // Create a new row as a copy of the random row
                DataRow newRow = dataTable.NewRow();
                foreach (DataColumn column in dataTable.Columns)
                {
                    newRow[column.ColumnName] = randomRow[column.ColumnName];
                }

                // Update the specific columns we want to change
                if (hasSalesOrderID)
                {
                    newRow["SalesOrderID"] = maxSalesOrderID + 1;
                }

                if (hasSalesOrderNumber)
                {
                    newRow["SalesOrderNumber"] = $"SO{maxSalesOrderID + 1}";
                }

                if (hasShipDate)
                {
                    // Set the ShipDate to today's date
                    if (dataTable.Columns["ShipDate"].DataType == typeof(DateTime))
                    {
                        newRow["ShipDate"] = DateTime.Today;
                    }
                    else
                    {
                        // If it's stored as string, format it as yyyy-MM-dd
                        newRow["ShipDate"] = DateTime.Today.ToString("yyyy-MM-dd");
                    }
                }

                // Add the new row to the DataTable
                dataTable.Rows.Add(newRow);

                // Append the new row to the CSV file
                if (!string.IsNullOrEmpty(csvFilePath))
                {
                    AppendRowToCSV(newRow, csvFilePath);
                }

                // Scroll to show the new row in the DataGridView
                if (table.Rows.Count > 0)
                {
                    table.FirstDisplayedScrollingRowIndex = table.Rows.Count - 1;
                    table.Rows[table.Rows.Count - 1].Selected = true;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error adding record: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        // CSV Methods
        private void LoadCSVData(string filePath)
        {
            try
            {
                // Clear existing data
                dataTable.Clear();
                dataTable.Columns.Clear();

                // Read all lines from the CSV file
                string[] lines = File.ReadAllLines(filePath);

                if (lines.Length == 0)
                {
                    MessageBox.Show("The CSV file is empty.", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    return;
                }

                // Get headers
                string[] headers = lines[0].Split(',');

                // Add columns to DataTable
                foreach (string header in headers)
                {
                    dataTable.Columns.Add(header.Trim());
                }

                // Add data rows
                for (int i = 1; i < lines.Length; i++)
                {
                    string[] data = lines[i].Split(',');

                    if (data.Length == headers.Length)
                    {
                        DataRow row = dataTable.NewRow();

                        for (int j = 0; j < headers.Length; j++)
                        {
                            row[j] = data[j].Trim();
                        }

                        dataTable.Rows.Add(row);
                    }
                }

                // Attempt to detect and convert column types
                DetectAndConvertColumnTypes();

                MessageBox.Show("CSV file loaded successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error loading CSV data: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void DetectAndConvertColumnTypes()
        {
            // Skip if no data
            if (dataTable.Rows.Count == 0)
                return;

            foreach (DataColumn column in dataTable.Columns.Cast<DataColumn>().ToList())
            {
                bool isInt = true;
                bool isDouble = true;
                bool isDateTime = true;

                // Check each value in the column
                foreach (DataRow row in dataTable.Rows)
                {
                    string value = row[column].ToString().Trim();

                    // Skip empty values
                    if (string.IsNullOrEmpty(value))
                        continue;

                    // Check if value can be converted to int
                    if (isInt && !int.TryParse(value, out _))
                    {
                        isInt = false;
                    }

                    // Check if value can be converted to double
                    if (isDouble && !double.TryParse(value, out _))
                    {
                        isDouble = false;
                    }

                    // Check if value can be converted to DateTime
                    if (isDateTime && !DateTime.TryParse(value, out _))
                    {
                        isDateTime = false;
                    }

                    // If all type checks failed, no need to continue
                    if (!isInt && !isDouble && !isDateTime)
                        break;
                }

                // Create a new column with appropriate data type
                DataColumn newColumn = null;

                if (isInt)
                {
                    newColumn = new DataColumn(column.ColumnName, typeof(int));
                }
                else if (isDouble)
                {
                    newColumn = new DataColumn(column.ColumnName, typeof(double));
                }
                else if (isDateTime)
                {
                    newColumn = new DataColumn(column.ColumnName, typeof(DateTime));
                }

                // If we can convert to a specific type, replace the column
                if (newColumn != null)
                {
                    int ordinal = column.Ordinal;
                    dataTable.Columns.Remove(column);
                    dataTable.Columns.Add(newColumn);
                    newColumn.SetOrdinal(ordinal);

                    // Convert values in the DataTable
                    foreach (DataRow row in dataTable.Rows)
                    {
                        string value = row[newColumn].ToString().Trim();

                        if (!string.IsNullOrEmpty(value))
                        {
                            if (isInt)
                            {
                                row[newColumn] = int.Parse(value);
                            }
                            else if (isDouble)
                            {
                                row[newColumn] = double.Parse(value);
                            }
                            else if (isDateTime)
                            {
                                row[newColumn] = DateTime.Parse(value);
                            }
                        }
                    }
                }
            }
        }

        private void AppendRowToCSV(DataRow row, string filePath)
        {
            try
            {
                StringBuilder line = new StringBuilder();

                // Build CSV line from row values
                for (int i = 0; i < dataTable.Columns.Count; i++)
                {
                    string value = row[i].ToString();

                    // Check if value contains comma or quotes
                    if (value.Contains(",") || value.Contains("\""))
                    {
                        // Escape quotes and wrap in quotes
                        value = $"\"{value.Replace("\"", "\"\"")}\"";
                    }

                    line.Append(value);

                    // Add comma unless it's the last column
                    if (i < dataTable.Columns.Count - 1)
                    {
                        line.Append(",");
                    }
                }

                // Append the line to the CSV file
                File.AppendAllText(filePath, Environment.NewLine + line.ToString());
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error appending to CSV file: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void FilterChanged(object sender, EventArgs e)
        {
            ApplyFilters();
        }

        private void ApplyFilters()
        {
            if (dataTable == null || dataTable.Rows.Count == 0)
                return;

            // Create a DataView from the original DataTable
            DataView view = new DataView(dataTable);

            // Build filter string
            var filters = new List<string>();

            if (comboBox1.SelectedItem != null)
                filters.Add($"Region = '{comboBox1.SelectedItem.ToString().Replace("'", "''")}'");

            if (comboBox2.SelectedItem != null)
                filters.Add($"Territory = '{comboBox2.SelectedItem.ToString().Replace("'", "''")}'");

            if (comboBox3.SelectedItem != null)
                filters.Add($"ProductCategory = '{comboBox3.SelectedItem.ToString().Replace("'", "''")}'");

            // Apply filter if any
            view.RowFilter = string.Join(" AND ", filters);

            // Bind the filtered view to the DataGridView
            table.DataSource = view;
        }


        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}