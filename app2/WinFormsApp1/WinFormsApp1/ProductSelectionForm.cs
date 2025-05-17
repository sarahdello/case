using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace WinFormsApp1
{
    public partial class ProductSelectionForm : Form
    {
        public string SelectedProduct { get; private set; }

        public ProductSelectionForm(List<string> products)
        {
            InitializeComponent();
            comboBoxProducts.Items.AddRange(new object[] { "Accessories", "Bikes", "Clothing", "Components" });

        }

        private void confirmButton_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrWhiteSpace(comboBoxProducts.Text))
            {
                SelectedProduct = comboBoxProducts.Text;
                this.DialogResult = DialogResult.OK;
                this.Close();
            }
            else
            {
                MessageBox.Show("Please select a product.");
            }
        }
    }
}
