namespace WinFormsApp1
{
    partial class Form1
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            header = new Panel();
            addSale = new Button();
            load = new Button();
            label1 = new Label();
            sidebar = new Panel();
            table = new DataGridView();
            header.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)table).BeginInit();
            SuspendLayout();
            // 
            // header
            // 
            header.BackColor = Color.FromArgb(249, 168, 0);
            header.Controls.Add(addSale);
            header.Controls.Add(load);
            header.Controls.Add(label1);
            header.Dock = DockStyle.Top;
            header.Location = new Point(0, 0);
            header.Name = "header";
            header.Size = new Size(1014, 40);
            header.TabIndex = 0;
            // 
            // addSale
            // 
            addSale.BackColor = Color.FromArgb(149, 165, 166);
            addSale.Location = new Point(287, 9);
            addSale.Name = "addSale";
            addSale.Size = new Size(94, 29);
            addSale.TabIndex = 2;
            addSale.Text = "+ Add Sale";
            addSale.UseVisualStyleBackColor = false;
            // 
            // load
            // 
            load.BackColor = Color.FromArgb(149, 165, 166);
            load.Location = new Point(187, 9);
            load.Name = "load";
            load.Size = new Size(94, 29);
            load.TabIndex = 1;
            load.Text = "Load";
            load.UseVisualStyleBackColor = false;
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new Point(12, 10);
            label1.Name = "label1";
            label1.Size = new Size(169, 20);
            label1.TabIndex = 0;
            label1.Text = "Stryker Sales Dashboard";
            // 
            // sidebar
            // 
            sidebar.BackColor = SystemColors.ControlLight;
            sidebar.Dock = DockStyle.Left;
            sidebar.Location = new Point(0, 40);
            sidebar.Name = "sidebar";
            sidebar.Size = new Size(300, 426);
            sidebar.TabIndex = 1;
            // 
            // table
            // 
            table.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            table.Dock = DockStyle.Fill;
            table.Location = new Point(300, 40);
            table.Name = "table";
            table.RowHeadersWidth = 51;
            table.Size = new Size(714, 426);
            table.TabIndex = 2;
            // 
            // Form1
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(1014, 466);
            Controls.Add(table);
            Controls.Add(sidebar);
            Controls.Add(header);
            Name = "Form1";
            Text = "Form1";
            Load += Form1_Load;
            header.ResumeLayout(false);
            header.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)table).EndInit();
            ResumeLayout(false);
        }

        #endregion

        private Panel header;
        private Panel sidebar;
        private Label label1;
        private Button load;
        private Button addSale;
        private DataGridView table;
    }
}