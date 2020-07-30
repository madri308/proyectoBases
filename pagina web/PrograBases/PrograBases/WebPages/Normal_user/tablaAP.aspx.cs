using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PrograBases.WebPages.Normal_user
{
    public partial class tablaAP : System.Web.UI.Page
    {
        private string selectArreglosDePagoSPName = "SP_APdeUsuarioSelect";
        private string selectMovimientosDeArregloSPName = "SP_MovDeAPSelect";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                fillGridAP();
            }
        }

        protected void fillGridAP()
        {
            string numFinca = (string)Session["numFinca"];
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                {
                    string procedure = selectArreglosDePagoSPName;

                    SqlCommand cmd = new SqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@inNumfinca", SqlDbType.VarChar).Value = numFinca;

                    cmd.Connection = conn;
                    conn.Open();

                    GridAP.DataSource = cmd.ExecuteReader();
                    GridAP.DataBind();
                    GridAP.Visible = true;
                }
            }
            catch (SqlException ex)
            {
                string alertMessage = Utilidad.mensajeAlerta(ex);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + alertMessage + "')", true);
            }
        }

        protected void fillGridMovimientos(int pIdAP)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                {
                    string procedure = selectMovimientosDeArregloSPName;

                    SqlCommand cmd = new SqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@inAPid", SqlDbType.VarChar).Value = pIdAP;

                    cmd.Connection = conn;
                    conn.Open();

                    GridMovimientos.DataSource = cmd.ExecuteReader();
                    GridMovimientos.DataBind();
                    GridMovimientos.Visible = true;
                }
            }
            catch (SqlException ex)
            {
                string alertMessage = Utilidad.mensajeAlerta(ex);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + alertMessage + "')", true);
            }
        }

        protected void lnkvVerMovimientos_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            int rowIndex = Convert.ToInt32(row.RowIndex);
            int idAP = (int)GridAP.DataKeys[rowIndex]["id"];
            fillGridMovimientos(idAP);
            divAP.Visible = false;
            divMovimientos.Visible = true;
        }
    }
}