
namespace ĐặtLệnhMuaBán
{
    partial class Form1
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
            this.components = new System.ComponentModel.Container();
            this.dataGridView1 = new System.Windows.Forms.DataGridView();
            this.iDDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.mACPDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.nGAYDATDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.lOAIGDDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.lOAILENHDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.sOLUONGDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.gIADATDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.tRANGTHAILENHDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.lENHDATBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.cHUNGKHOANDataSet = new ĐặtLệnhMuaBán.CHUNGKHOANDataSet();
            this.lENHDATTableAdapter = new ĐặtLệnhMuaBán.CHUNGKHOANDataSetTableAdapters.LENHDATTableAdapter();
            this.btnBangGiaTrucTuyen = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.btnGiaoDich = new System.Windows.Forms.Button();
            this.cbgiaodich = new System.Windows.Forms.ComboBox();
            this.inputmacp = new DevExpress.XtraEditors.TextEdit();
            this.inputsoluong = new DevExpress.XtraEditors.SpinEdit();
            this.inputgiadat = new DevExpress.XtraEditors.SpinEdit();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.lENHDATBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.cHUNGKHOANDataSet)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.inputmacp.Properties)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.inputsoluong.Properties)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.inputgiadat.Properties)).BeginInit();
            this.SuspendLayout();
            // 
            // dataGridView1
            // 
            this.dataGridView1.AllowUserToAddRows = false;
            this.dataGridView1.AutoGenerateColumns = false;
            this.dataGridView1.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dataGridView1.AutoSizeRowsMode = System.Windows.Forms.DataGridViewAutoSizeRowsMode.AllCells;
            this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView1.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.iDDataGridViewTextBoxColumn,
            this.mACPDataGridViewTextBoxColumn,
            this.nGAYDATDataGridViewTextBoxColumn,
            this.lOAIGDDataGridViewTextBoxColumn,
            this.lOAILENHDataGridViewTextBoxColumn,
            this.sOLUONGDataGridViewTextBoxColumn,
            this.gIADATDataGridViewTextBoxColumn,
            this.tRANGTHAILENHDataGridViewTextBoxColumn});
            this.dataGridView1.DataSource = this.lENHDATBindingSource;
            this.dataGridView1.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.dataGridView1.Location = new System.Drawing.Point(0, 258);
            this.dataGridView1.Name = "dataGridView1";
            this.dataGridView1.ReadOnly = true;
            this.dataGridView1.RowHeadersWidth = 51;
            this.dataGridView1.RowTemplate.Height = 24;
            this.dataGridView1.Size = new System.Drawing.Size(1282, 275);
            this.dataGridView1.TabIndex = 0;
            this.dataGridView1.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dataGridView1_CellContentClick);
            // 
            // iDDataGridViewTextBoxColumn
            // 
            this.iDDataGridViewTextBoxColumn.DataPropertyName = "ID";
            this.iDDataGridViewTextBoxColumn.HeaderText = "ID";
            this.iDDataGridViewTextBoxColumn.MinimumWidth = 6;
            this.iDDataGridViewTextBoxColumn.Name = "iDDataGridViewTextBoxColumn";
            this.iDDataGridViewTextBoxColumn.ReadOnly = true;
            // 
            // mACPDataGridViewTextBoxColumn
            // 
            this.mACPDataGridViewTextBoxColumn.DataPropertyName = "MACP";
            this.mACPDataGridViewTextBoxColumn.HeaderText = "MACP";
            this.mACPDataGridViewTextBoxColumn.MinimumWidth = 6;
            this.mACPDataGridViewTextBoxColumn.Name = "mACPDataGridViewTextBoxColumn";
            // 
            // nGAYDATDataGridViewTextBoxColumn
            // 
            this.nGAYDATDataGridViewTextBoxColumn.DataPropertyName = "NGAYDAT";
            this.nGAYDATDataGridViewTextBoxColumn.HeaderText = "NGAYDAT";
            this.nGAYDATDataGridViewTextBoxColumn.MinimumWidth = 6;
            this.nGAYDATDataGridViewTextBoxColumn.Name = "nGAYDATDataGridViewTextBoxColumn";
            // 
            // lOAIGDDataGridViewTextBoxColumn
            // 
            this.lOAIGDDataGridViewTextBoxColumn.DataPropertyName = "LOAIGD";
            this.lOAIGDDataGridViewTextBoxColumn.HeaderText = "LOAIGD";
            this.lOAIGDDataGridViewTextBoxColumn.MinimumWidth = 6;
            this.lOAIGDDataGridViewTextBoxColumn.Name = "lOAIGDDataGridViewTextBoxColumn";
            // 
            // lOAILENHDataGridViewTextBoxColumn
            // 
            this.lOAILENHDataGridViewTextBoxColumn.DataPropertyName = "LOAILENH";
            this.lOAILENHDataGridViewTextBoxColumn.HeaderText = "LOAILENH";
            this.lOAILENHDataGridViewTextBoxColumn.MinimumWidth = 6;
            this.lOAILENHDataGridViewTextBoxColumn.Name = "lOAILENHDataGridViewTextBoxColumn";
            // 
            // sOLUONGDataGridViewTextBoxColumn
            // 
            this.sOLUONGDataGridViewTextBoxColumn.DataPropertyName = "SOLUONG";
            this.sOLUONGDataGridViewTextBoxColumn.HeaderText = "SOLUONG";
            this.sOLUONGDataGridViewTextBoxColumn.MinimumWidth = 6;
            this.sOLUONGDataGridViewTextBoxColumn.Name = "sOLUONGDataGridViewTextBoxColumn";
            // 
            // gIADATDataGridViewTextBoxColumn
            // 
            this.gIADATDataGridViewTextBoxColumn.DataPropertyName = "GIADAT";
            this.gIADATDataGridViewTextBoxColumn.HeaderText = "GIADAT";
            this.gIADATDataGridViewTextBoxColumn.MinimumWidth = 6;
            this.gIADATDataGridViewTextBoxColumn.Name = "gIADATDataGridViewTextBoxColumn";
            // 
            // tRANGTHAILENHDataGridViewTextBoxColumn
            // 
            this.tRANGTHAILENHDataGridViewTextBoxColumn.DataPropertyName = "TRANGTHAILENH";
            this.tRANGTHAILENHDataGridViewTextBoxColumn.HeaderText = "TRANGTHAILENH";
            this.tRANGTHAILENHDataGridViewTextBoxColumn.MinimumWidth = 6;
            this.tRANGTHAILENHDataGridViewTextBoxColumn.Name = "tRANGTHAILENHDataGridViewTextBoxColumn";
            // 
            // lENHDATBindingSource
            // 
            this.lENHDATBindingSource.DataMember = "LENHDAT";
            this.lENHDATBindingSource.DataSource = this.cHUNGKHOANDataSet;
            // 
            // cHUNGKHOANDataSet
            // 
            this.cHUNGKHOANDataSet.DataSetName = "CHUNGKHOANDataSet";
            this.cHUNGKHOANDataSet.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
            // 
            // lENHDATTableAdapter
            // 
            this.lENHDATTableAdapter.ClearBeforeFill = true;
            // 
            // btnBangGiaTrucTuyen
            // 
            this.btnBangGiaTrucTuyen.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(230)))), ((int)(((byte)(119)))), ((int)(((byte)(46)))));
            this.btnBangGiaTrucTuyen.Font = new System.Drawing.Font("Tahoma", 10F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnBangGiaTrucTuyen.ForeColor = System.Drawing.Color.White;
            this.btnBangGiaTrucTuyen.Location = new System.Drawing.Point(692, 99);
            this.btnBangGiaTrucTuyen.Name = "btnBangGiaTrucTuyen";
            this.btnBangGiaTrucTuyen.Size = new System.Drawing.Size(230, 43);
            this.btnBangGiaTrucTuyen.TabIndex = 25;
            this.btnBangGiaTrucTuyen.Text = "Bảng Giá Trực Tuyến";
            this.btnBangGiaTrucTuyen.UseVisualStyleBackColor = false;
            this.btnBangGiaTrucTuyen.Click += new System.EventHandler(this.btnBangGiaTrucTuyen_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Tahoma", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(56, 35);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(101, 21);
            this.label1.TabIndex = 18;
            this.label1.Text = "Mã Cổ Phiếu";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Tahoma", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.Location = new System.Drawing.Point(56, 90);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(116, 21);
            this.label2.TabIndex = 19;
            this.label2.Text = "Loại Giao Dịch";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Tahoma", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.Location = new System.Drawing.Point(56, 138);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(78, 21);
            this.label3.TabIndex = 20;
            this.label3.Text = "Số Lượng";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Tahoma", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.Location = new System.Drawing.Point(56, 198);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(66, 21);
            this.label4.TabIndex = 21;
            this.label4.Text = "Giá Đặt";
            this.label4.Click += new System.EventHandler(this.label4_Click);
            // 
            // btnGiaoDich
            // 
            this.btnGiaoDich.BackColor = System.Drawing.Color.Red;
            this.btnGiaoDich.Font = new System.Drawing.Font("Tahoma", 10F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnGiaoDich.ForeColor = System.Drawing.Color.White;
            this.btnGiaoDich.Location = new System.Drawing.Point(442, 99);
            this.btnGiaoDich.Name = "btnGiaoDich";
            this.btnGiaoDich.Size = new System.Drawing.Size(170, 43);
            this.btnGiaoDich.TabIndex = 23;
            this.btnGiaoDich.Text = "Đặt Lệnh";
            this.btnGiaoDich.UseVisualStyleBackColor = false;
            this.btnGiaoDich.Click += new System.EventHandler(this.btnGiaoDich_Click);
            // 
            // cbgiaodich
            // 
            this.cbgiaodich.FormattingEnabled = true;
            this.cbgiaodich.Items.AddRange(new object[] {
            "M",
            "B"});
            this.cbgiaodich.Location = new System.Drawing.Point(186, 87);
            this.cbgiaodich.Name = "cbgiaodich";
            this.cbgiaodich.Size = new System.Drawing.Size(97, 24);
            this.cbgiaodich.TabIndex = 22;
            // 
            // inputmacp
            // 
            this.inputmacp.Location = new System.Drawing.Point(186, 36);
            this.inputmacp.Name = "inputmacp";
            this.inputmacp.Size = new System.Drawing.Size(176, 22);
            this.inputmacp.TabIndex = 27;
            // 
            // inputsoluong
            // 
            this.inputsoluong.EditValue = new decimal(new int[] {
            1000,
            0,
            0,
            0});
            this.inputsoluong.Location = new System.Drawing.Point(187, 138);
            this.inputsoluong.Name = "inputsoluong";
            this.inputsoluong.Properties.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[] {
            new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)});
            this.inputsoluong.Size = new System.Drawing.Size(175, 24);
            this.inputsoluong.TabIndex = 30;
            // 
            // inputgiadat
            // 
            this.inputgiadat.EditValue = new decimal(new int[] {
            10000,
            0,
            0,
            0});
            this.inputgiadat.Location = new System.Drawing.Point(187, 194);
            this.inputgiadat.Name = "inputgiadat";
            this.inputgiadat.Properties.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[] {
            new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)});
            this.inputgiadat.Size = new System.Drawing.Size(175, 24);
            this.inputgiadat.TabIndex = 31;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoSize = true;
            this.ClientSize = new System.Drawing.Size(1282, 533);
            this.Controls.Add(this.inputgiadat);
            this.Controls.Add(this.inputsoluong);
            this.Controls.Add(this.inputmacp);
            this.Controls.Add(this.btnBangGiaTrucTuyen);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.btnGiaoDich);
            this.Controls.Add(this.cbgiaodich);
            this.Controls.Add(this.dataGridView1);
            this.Name = "Form1";
            this.Text = "Form1";
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.lENHDATBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.cHUNGKHOANDataSet)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.inputmacp.Properties)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.inputsoluong.Properties)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.inputgiadat.Properties)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.DataGridView dataGridView1;
        private CHUNGKHOANDataSet cHUNGKHOANDataSet;
        private System.Windows.Forms.BindingSource lENHDATBindingSource;
        private CHUNGKHOANDataSetTableAdapters.LENHDATTableAdapter lENHDATTableAdapter;
        private System.Windows.Forms.DataGridViewTextBoxColumn iDDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn mACPDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn nGAYDATDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn lOAIGDDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn lOAILENHDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn sOLUONGDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn gIADATDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn tRANGTHAILENHDataGridViewTextBoxColumn;
        private System.Windows.Forms.Button btnBangGiaTrucTuyen;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Button btnGiaoDich;
        private System.Windows.Forms.ComboBox cbgiaodich;
        private DevExpress.XtraEditors.TextEdit inputmacp;
        private DevExpress.XtraEditors.SpinEdit inputsoluong;
        private DevExpress.XtraEditors.SpinEdit inputgiadat;
    }
}

