using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Security.Permissions;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ĐặtLệnhMuaBán
{
    public partial class Bảng_Giá_Trực_Tuyến : Form
    {
        private const String tableName = "BANGGIATRUCTUYEN_LO";
        private int changeCount = 0;
        private SqlConnection connection = null;
        private SqlCommand command = null;
        private DataSet dataToWatch = null;
        private Boolean CanRequestNotifications()
        {
            try
            {
                SqlClientPermission perm = new SqlClientPermission(PermissionState.Unrestricted);
                perm.Demand();
                return true;
            }
            catch (Exception e)
            {
                return false;
            }
        }

        private String GetSQL()
        {
            return "select MACP,GIAMUA1,SOLUONGM1,GIAMUA2,SOLUONGM2,GIAMUA3,SOLUONGM3,GIABAN1,SOLUONGB1,GIABAN2,SOLUONGB2," +
                "GIABAN3,SOLUONGB3,GIAKHOP,SOLUONGKHOP,TANGGIAMGIA,TONGSOLUONG from dbo.BANGGIATRUCTUYEN_LO";
        }
        public Bảng_Giá_Trực_Tuyến()
        {
            InitializeComponent();
        }

        private void Bảng_Giá_Trực_Tuyến_Load(object sender, EventArgs e)
        {
            // TODO: This line of code loads data into the 'cHUNGKHOANDataSet.BANGGIATRUCTUYEN_LO' table. You can move, or remove it, as needed.
            this.bANGGIATRUCTUYEN_LOTableAdapter.Fill(this.cHUNGKHOANDataSet.BANGGIATRUCTUYEN_LO);
            if (CanRequestNotifications() == true)
            {
                Program.KetNoi();
                BatDau();
            }
            else
            {
                MessageBox.Show("Bạn chưa kích hoạt dịch vụ Broker", "", MessageBoxButtons.OK);
            }

        }
        private void BatDau()
        {
            changeCount = 0;
            SqlDependency.Stop(Program.connectionString);
            try
            {
                SqlDependency.Start(Program.connectionString);
            }
            catch (Exception e)
            {
                MessageBox.Show(e.Message, "", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                return;
            }
            if (connection == null)
            {
                connection = new SqlConnection(Program.connectionString);
                connection.Open();
            }
            if (command == null)
            {
                command = new SqlCommand(GetSQL(), connection);
            }

            if (dataToWatch == null)
            {
                dataToWatch = new DataSet();
            }

            GetData();
        }

        private void GetData()
        {
            dataToWatch.Clear();

            command.Notification = null;

            SqlDependency dependency = new SqlDependency(command);
            dependency.OnChange += dependency_OnChange;

            using (SqlDataAdapter adapter = new SqlDataAdapter(command))
            {
                adapter.Fill(dataToWatch, tableName);
                this.databanggiatructuyen.AutoGenerateColumns = false;
                this.databanggiatructuyen.DataSource = dataToWatch;
                this.databanggiatructuyen.DataMember = tableName;
            }
        }

        private void dependency_OnChange(object sender, SqlNotificationEventArgs e)
        {
            try
            {
                ISynchronizeInvoke i = (ISynchronizeInvoke)this;

                if (i.InvokeRequired)
                {
                    OnChangeEventHandler tempDelegate = new OnChangeEventHandler(dependency_OnChange);

                    object[] args = { sender, e };

                    i.BeginInvoke(tempDelegate, args);
                    return;
                }

                SqlDependency dependency = (SqlDependency)sender;

                dependency.OnChange -= dependency_OnChange;

                changeCount += 1;
                GetData();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }

        }
    }
}
