using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace score_m.dbc
{
    public class DatabaseConnect
    {
        private SqlConnection conn = null;
        private void log(string str)
        {
            System.Diagnostics.Debug.WriteLine(str);
        }
        public DatabaseConnect()
        {
            conn = new SqlConnection();
            conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MyDB"].ConnectionString;
        }

        public void openDatabase()
        {
            if (conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }
        }

        public int exc(string sql)
        {
            int Flag = 0;
            conn.Open();
            try
            {
                SqlCommand cmd = new SqlCommand(sql, conn);
                Flag = cmd.ExecuteNonQuery();
            }catch(Exception e)
            { log(e.Message); }
            finally
            {
                conn.Close();
            }
            return Flag;
        }

        public DataTable excList(string sql)
        {
            conn.Open();
            SqlDataAdapter da = new SqlDataAdapter(sql, conn);
            DataTable dt = new DataTable();
            da.Fill(dt);
            conn.Close();
            return dt;
        }
    }
}