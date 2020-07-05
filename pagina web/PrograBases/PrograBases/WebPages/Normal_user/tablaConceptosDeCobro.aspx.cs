using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace PrograBases.WebPages.Normal_user
{
    public partial class tablaConceptosDeCobro : System.Web.UI.Page
    {
        private string getConceptosDeCobroDePropiedadSPname = "SP_getCCdePropiedad";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                fillGridConceptoDeCobro();
            }
        }

        protected void fillGridConceptoDeCobro()
        {
            string numFinca = (string)Session["numFinca"];
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                {
                    string procedure = getConceptosDeCobroDePropiedadSPname;

                    SqlCommand cmd = new SqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@inNumfinca", SqlDbType.VarChar).Value = numFinca;

                    cmd.Connection = conn;
                    conn.Open();

                    GridConceptosDeCobro.DataSource = cmd.ExecuteReader();
                    GridConceptosDeCobro.DataBind();
                    GridConceptosDeCobro.Visible = true;
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