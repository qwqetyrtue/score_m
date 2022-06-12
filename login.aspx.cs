using score_m.dbc;
using System;
using System.Data;

namespace score_m
{
    public partial class login : System.Web.UI.Page
    {
        private DatabaseConnect dbc = new DatabaseConnect();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Button1_Click(object sender, EventArgs e)
        {

            string id = idInput.Text;
            string password = passwordInput.Text;
            string role = roleInput.Text;
            if (Session[role] != null)
            {
                Response.Redirect($"{role}.aspx");
            }
            string idname = role.Equals("admin") ? "mid" : "sid";
            Response.Write($"SELECT * FROM {role} WHERE {idname}={id} AND password={password}");
            DataTable res = dbc.excList($"SELECT * FROM {role} WHERE { idname}='{id}' AND password='{password}'");
            if (res.Rows.Count == 1)
            {
                Session[role] = id;
                Response.Redirect($"{role}.aspx");
            }
            else
                Response.Redirect("login.aspx");
        }
    }
}