using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ĐặtLệnhMuaBán
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }
        private Form CheckExists(Type ftype)
        {
            foreach (Form f in this.MdiChildren)
                if (f.GetType() == ftype)
                    return f;
            return null;
        }
        private void Form1_Load(object sender, EventArgs e)
        {
            cbgiaodich.SelectedIndex = 0;
            // TODO: This line of code loads data into the 'cHUNGKHOANDataSet.LENHDAT' table. You can move, or remove it, as needed.
            this.lENHDATTableAdapter.Fill(this.cHUNGKHOANDataSet.LENHDAT);

        }
        private bool kiemTraDuLieuDauVao()
        {
            if (inputmacp.Text == "")
            {

                MessageBox.Show("Hãy nhập mã cổ phiểu", "Thông báo", MessageBoxButtons.OK);
                inputmacp.Focus();
                return false;
            }

            if (inputsoluong.Value < 100 || (inputsoluong.Value) % 100 != 0)
            {
                MessageBox.Show("Số lượng tối thiểu là 100 và chia hết cho 100 ", "Thông báo", MessageBoxButtons.OK);
                inputsoluong.Focus();
                return false;
            }

            if (inputgiadat.Value < 0)
            {
                MessageBox.Show("Giá đặt tối thiểu là 1", "Thông báo", MessageBoxButtons.OK);
                inputgiadat.Focus();
                return false;
            }

            return true;
        }
        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void label4_Click(object sender, EventArgs e)
        {

        }

        private void btnLenhDat_Click(object sender, EventArgs e)
        {

        }

        private void inputsoluong_EditValueChanged(object sender, EventArgs e)
        {

        }

        private void btnBangGiaTrucTuyen_Click(object sender, EventArgs e)
        {
            Form f = this.CheckExists(typeof(Bảng_Giá_Trực_Tuyến));
            if (f != null)
            {
                f.Activate();
            }
            else
            {
                Bảng_Giá_Trực_Tuyến form = new Bảng_Giá_Trực_Tuyến();
                form.WindowState = FormWindowState.Maximized;
                form.Show();
               
                btnBangGiaTrucTuyen.Enabled = false;
            }
        }

        private void btnGiaoDich_Click(object sender, EventArgs e)
        {
            bool ketQua = kiemTraDuLieuDauVao();
            if (ketQua == false)
            {
                return;
            }
            Program.KetNoi();
            String query = "INSERT INTO LENHDAT(MACP, LOAIGD, SOLUONG, GIADAT) VALUES(N'" + inputmacp.Text 
                + "', N'" + cbgiaodich.SelectedItem +"', " + inputsoluong.Value + ", " + inputgiadat.Value + ")";
            Program.myReader = Program.ExecSqlDataReader(query);
            if (Program.myReader == null)
            {
                return;
            }
            Program.myReader.Read();
            Program.myReader.Close();
            this.lENHDATTableAdapter.Fill(this.cHUNGKHOANDataSet.LENHDAT);
            reset();
        }

        private void reset()
        {
            inputmacp.Text = "";
            inputgiadat.Value = 0;
            inputsoluong.Value = 0;
        }
    }
}
