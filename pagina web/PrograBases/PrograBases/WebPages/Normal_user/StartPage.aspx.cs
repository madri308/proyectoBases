using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PrograBases.WebPages.Normal_user
{
    public partial class StartPage : System.Web.UI.Page
    {
        private string verPropiedadesDeUsuario = "SP_getPropertyOfUsers";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                fillGridPropiedades();
            }
        }

        protected void fillGridPropiedades()
        {
            string user = (string) Session["userName"];
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                {
                    string procedure = verPropiedadesDeUsuario;

                    SqlCommand cmd = new SqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@inUsuario", SqlDbType.VarChar).Value = user;

                    cmd.Connection = conn;
                    conn.Open();

                    GridPropiedades.DataSource = cmd.ExecuteReader();
                    GridPropiedades.DataBind();
                    GridPropiedades.Visible = true;
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