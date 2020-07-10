using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PrograBases.WebPages.Normal_user
{
    public partial class tablaComprobantesDePago : System.Web.UI.Page
    {
        private string getComprobantesDePagoSPName = "SP_ComprobantePagoSelect";
        private string getAllComprobantesDePagoSPName = "SP_ComprobantePagoPorPropiedadSelect";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                fillGridComprobantes();
            }
        }

        protected void fillGridComprobantes()
        {
            int opcionComprobante = (int)Session["opcionComprobante"];
            string numFinca = (string)Session["numFinca"];
            if (opcionComprobante == 1)
            {
                int idRecibo = (int)(Session["idRecibo"]);
                try
                {
                    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                    {
                        string procedure = getComprobantesDePagoSPName;

                        SqlCommand cmd = new SqlCommand(procedure, conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        //cmd.Parameters.Add("@inNumfinca", SqlDbType.VarChar).Value = numFinca;
                        cmd.Parameters.Add("@inIdRecibo", SqlDbType.VarChar).Value = idRecibo;

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
            else
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                    {
                        string procedure = getAllComprobantesDePagoSPName;

                        SqlCommand cmd = new SqlCommand(procedure, conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        //cmd.Parameters.Add("@inNumfinca", SqlDbType.VarChar).Value = numFinca;
                        cmd.Parameters.Add("@inNumFinca", SqlDbType.VarChar).Value = numFinca;

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

        protected void lnkvVerRecibosDeComprobante_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            int rowIndex = Convert.ToInt32(row.RowIndex);
            int idComprobante = (int)GridComprobantesDePago.DataKeys[rowIndex]["id"];
            Session["idComprobante"] = idComprobante;
            Session["opcionRecibosDeComprobante"] = 1;
            Response.Redirect("~/WebPages/Normal_user/tablaRecibos.aspx");
        }
    }
}