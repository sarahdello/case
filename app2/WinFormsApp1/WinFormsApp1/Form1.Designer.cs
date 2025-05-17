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
            label1 = new Label();
            sidebar = new Panel();
            comboBox3 = new ComboBox();
            label4 = new Label();
            comboBox2 = new ComboBox();
            label3 = new Label();
            label2 = new Label();
            comboBox1 = new ComboBox();
            table = new DataGridView();
            header.SuspendLayout();
            sidebar.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)table).BeginInit();
            SuspendLayout();
            // 
            // header
            // 
            header.BackColor = Color.FromArgb(249, 168, 0);
            header.Controls.Add(addSale);
            header.Controls.Add(label1);
            header.Dock = DockStyle.Top;
            header.Location = new Point(0, 0);
            header.Name = "header";
            header.Size = new Size(1178, 40);
            header.TabIndex = 0;
            // 
            // addSale
            // 
            addSale.BackColor = Color.FromArgb(149, 165, 166);
            addSale.Location = new Point(187, 7);
            addSale.Name = "addSale";
            addSale.Size = new Size(94, 29);
            addSale.TabIndex = 2;
            addSale.Text = "+ Add Sale";
            addSale.UseVisualStyleBackColor = false;
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
            sidebar.Controls.Add(comboBox3);
            sidebar.Controls.Add(label4);
            sidebar.Controls.Add(comboBox2);
            sidebar.Controls.Add(label3);
            sidebar.Controls.Add(label2);
            sidebar.Controls.Add(comboBox1);
            sidebar.Dock = DockStyle.Left;
            sidebar.Location = new Point(0, 40);
            sidebar.Name = "sidebar";
            sidebar.Size = new Size(300, 440);
            sidebar.TabIndex = 1;
            // 
            // comboBox3
            // 
            comboBox3.FormattingEnabled = true;
            comboBox3.Location = new Point(12, 175);
            comboBox3.Name = "comboBox3";
            comboBox3.Size = new Size(269, 28);
            comboBox3.TabIndex = 7;
            // 
            // label4
            // 
            label4.AutoSize = true;
            label4.Location = new Point(12, 152);
            label4.Name = "label4";
            label4.Size = new Size(120, 20);
            label4.TabIndex = 6;
            label4.Text = "ProductCategory";
            // 
            // comboBox2
            // 
            comboBox2.AllowDrop = true;
            comboBox2.FormattingEnabled = true;
            comboBox2.Location = new Point(12, 105);
            comboBox2.Name = "comboBox2";
            comboBox2.Size = new Size(269, 28);
            comboBox2.TabIndex = 5;
            // 
            // label3
            // 
            label3.AutoSize = true;
            label3.Location = new Point(12, 82);
            label3.Name = "label3";
            label3.Size = new Size(64, 20);
            label3.TabIndex = 4;
            label3.Text = "Territory";
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Location = new Point(12, 16);
            label2.Name = "label2";
            label2.Size = new Size(56, 20);
            label2.TabIndex = 3;
            label2.Text = "Region";
            label2.Click += label2_Click;
            // 
            // comboBox1
            // 
            comboBox1.AllowDrop = true;
            comboBox1.AutoCompleteMode = AutoCompleteMode.SuggestAppend;
            comboBox1.FormattingEnabled = true;
            comboBox1.Location = new Point(12, 39);
            comboBox1.Name = "comboBox1";
            comboBox1.Size = new Size(269, 28);
            comboBox1.TabIndex = 0;
            comboBox1.SelectedIndexChanged += comboBox1_SelectedIndexChanged;
            // 
            // table
            // 
            table.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            table.Dock = DockStyle.Fill;
            table.Location = new Point(300, 40);
            table.Name = "table";
            table.RowHeadersWidth = 51;
            table.Size = new Size(878, 440);
            table.TabIndex = 2;
            // 
            // Form1
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(1178, 480);
            Controls.Add(table);
            Controls.Add(sidebar);
            Controls.Add(header);
            Name = "Form1";
            Text = "Form1";
            Load += Form1_Load;
            header.ResumeLayout(false);
            header.PerformLayout();
            sidebar.ResumeLayout(false);
            sidebar.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)table).EndInit();
            ResumeLayout(false);
        }

        #endregion

        private Panel header;
        private Panel sidebar;
        private Label label1;
        private Button addSale;
        private DataGridView table;
        private Label label2;
        private ComboBox comboBox1;
        private ComboBox comboBox3;
        private Label label4;
        private ComboBox comboBox2;
        private Label label3;
    }
}