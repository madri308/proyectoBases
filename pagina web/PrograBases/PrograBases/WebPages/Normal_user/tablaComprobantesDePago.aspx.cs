using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace PrograBases.WebPages.Normal_user
{
    public partial class tablaComprobantesDePago : System.Web.UI.Page
    {
        private string getComprobantesDePagoSPName = "SP_ComprobantesDePagoSelect";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                fillGridComprobantes();
            }
        }

        protected void fillGridComprobantes()
        {
            string numFinca = (string)Session["numFinca"];
            int opcionRecibos = (int)Session["opcionRecibos"];
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                {
                    string procedure = getComprobantesDePagoSPName;

                    SqlCommand cmd = new SqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@inNumfinca", SqlDbType.VarChar).Value = numFinca;

                    cmd.Connection = conn;
                    conn.Open();

                    GridComprobantesDePago.DataSource = cmd.ExecuteReader();
                    GridComprobantesDePago.DataBind();
                    GridComprobantesDePago.Visible = true;
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