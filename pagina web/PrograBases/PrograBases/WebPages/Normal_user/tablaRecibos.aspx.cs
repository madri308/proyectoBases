using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PrograBases.WebPages.Normal_user
{
    public partial class tablaRecibos : System.Web.UI.Page
    {
        private string selectRecibosSpName = "SP_RecibosSelect";
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
            int opcionRecibos = (int)Session["opcionRecibos"];
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                {
                    string procedure = selectRecibosSpName;

                    SqlCommand cmd = new SqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@inNumfinca", SqlDbType.VarChar).Value = numFinca;
                    cmd.Parameters.Add("@inOpcionRecibos", SqlDbType.Int).Value = opcionRecibos;

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

        protected void lnkvVerComprobantesDePago_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            int rowIndex = Convert.ToInt32(row.RowIndex);
            int idRecibo = (int)GridRecibos.DataKeys[rowIndex]["id"];
            Session["idRecibo"] = idRecibo;
            Response.Redirect("~/WebPages/Normal_user/tablaComprobantesDePago.aspx");
        }
    }
}