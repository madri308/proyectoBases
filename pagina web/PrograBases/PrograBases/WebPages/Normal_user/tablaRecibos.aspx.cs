using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace PrograBases.WebPages.Normal_user
{
    public partial class tablaRecibos : System.Web.UI.Page
    {
        private string getRecibosSpName = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                fillGridRecibos();
            }
        }

        protected void fillGridRecibos()
        {
            string numFinca = (string)Session["numFinca"];
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                {
                    string procedure = getRecibosSpName;

                    SqlCommand cmd = new SqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@inNumfinca", SqlDbType.VarChar).Value = numFinca;

                    cmd.Connection = conn;
                    conn.Open();

                    GridRecibos.DataSource = cmd.ExecuteReader();
                    GridRecibos.DataBind();
                    GridRecibos.Visible = true;
                }
            }
            catch (SqlException ex)
            {
                string alertMessage = Utilidad.mensajeAlerta(ex);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + alertMessage + "')", true);
            }
        }
    }
}