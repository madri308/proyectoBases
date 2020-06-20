using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PrograBases.Pages
{
    public partial class loginPage : System.Web.UI.Page
    {
        static string checkUserSpName = "SP_checkUserAndPasswordSP";
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void loginButton_Click(object sender, EventArgs e)
        {
            try
            {
                int response = -1;
                String user = usernameTextBox.Text, password = passwordTextBox.Text;
                user = user.Trim(); password = password.Trim();
                if (String.IsNullOrEmpty(user)) user = "-1";
                if (String.IsNullOrEmpty(password)) password = "-1";

                try
                {
                    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                    {
                        SqlCommand cmd = new SqlCommand();
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = checkUserSpName;

                        cmd.Parameters.Add("@inPassword", SqlDbType.VarChar).Value = password;
                        cmd.Parameters.Add("@inNombre", SqlDbType.VarChar).Value = user;
                        // Parametro para el valor de retorno
                        SqlParameter returnParameter = cmd.Parameters.Add("RetVal", SqlDbType.Int);
                        returnParameter.Direction = ParameterDirection.ReturnValue;
                        // Se abre la conexion y se ejecuta el store procedure
                        cmd.Connection = conn;
                        conn.Open();
                        cmd.ExecuteNonQuery();

                        int id = (int)returnParameter.Value;
                        response = id;
                    }

                }
                catch (SqlException ex)
                {
                    string alertMessage = Utilidad.mensajeAlerta(ex);
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + alertMessage + "')", true);

                }
                if (response == 1) // Usuario administrador
                {
                    HttpContext.Current.Session["userType"] = 1;
                    Response.Redirect("~/WebPages/StartPage.aspx");
                }
                else if (response == 0) // Usuario corriente
                {
                    RespuestaLabel.Text = "Acceso solo a usuarios administradores";
                    RespuestaLabel.Visible = true;
                }
                else
                {
                    RespuestaLabel.Text = "Usuario o contraseña incorrecta";
                    RespuestaLabel.Visible = true;
                }
            }
            catch(SqlException ex)
            {
                RespuestaLabel.Text = "Usuario o contraseña incorrecta";
                RespuestaLabel.Visible = true;
            }
        }
    }
}