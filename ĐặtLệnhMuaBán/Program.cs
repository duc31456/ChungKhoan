using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ĐặtLệnhMuaBán
{
    static class Program
    {
        public static SqlConnection connection = new SqlConnection();
        public static SqlDataReader myReader;
        public static SqlCommand sqlcmd;

        public static string connectionString = "Data Source = DESKTOP-MMFEF8Q\\SQLEXPRESS; Initial Catalog = CHUNGKHOAN; User ID = sa; Password=123;";


        public static SqlDataReader ExecSqlDataReader(String strLenh) // doc du lieu
        {
            SqlDataReader myreader;
            SqlCommand sqlcmd = new SqlCommand(strLenh, connection);
            sqlcmd.CommandType = CommandType.Text;
            if (connection.State == ConnectionState.Closed) connection.Open();
            try
            {
                myreader = sqlcmd.ExecuteReader(); return myreader;
            }
            catch (SqlException ex)
            {
                connection.Close();
                MessageBox.Show(ex.Message);
                return null;
            }
        }

        public static int KetNoi()
        {
            try
            {
                connection = new SqlConnection(connectionString);
                connection.Open();
                return 1;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi kết nối database !!!" + ex.Message);
                return 0;
            }
        }
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new Form1());
        }
    }
}
