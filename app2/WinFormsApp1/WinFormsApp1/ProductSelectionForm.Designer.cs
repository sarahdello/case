namespace WinFormsApp1
{
    partial class ProductSelectionForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
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
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            comboBoxProducts = new ComboBox();
            SuspendLayout();
            // 
            // comboBoxProducts
            // 
            comboBoxProducts.AccessibleName = "comboBoxProducts";
            comboBoxProducts.Anchor = AnchorStyles.Left | AnchorStyles.Right;
            comboBoxProducts.FormattingEnabled = true;
            comboBoxProducts.Location = new Point(275, 173);
            comboBoxProducts.Name = "comboBoxProducts";
            comboBoxProducts.Size = new Size(210, 28);
            comboBoxProducts.TabIndex = 0;
            // 
            // ProductSelectionForm
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(800, 450);
            Controls.Add(comboBoxProducts);
            Name = "ProductSelectionForm";
            Text = "ProductSelectionForm";
            ResumeLayout(false);
        }

        #endregion

        private ComboBox comboBoxProducts;
    }
}