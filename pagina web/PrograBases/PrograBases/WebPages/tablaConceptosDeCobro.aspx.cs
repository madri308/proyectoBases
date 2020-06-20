using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PrograBases.WebPages
{
    public partial class tablaConceptosDeCobro : System.Web.UI.Page
    {
        private string getConceptosDeCobroSPname = "SP_ConceptoDeCobroSelect";
        private string getConceptosDeCobroDePropiedadSPname = "SP_getCCdePropiedad";
        private string deleteConceptoDeCobro = "SP_ConceptoDeCobroDelete";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) 
            {
                string all = Request.QueryString["all"];
                if (all == "true")
                    HttpContext.Current.Session["opcionDeBusqueda"] = -1;
                fillGridConceptoDeCobro();
            }
        }

        protected void fillGridConceptoDeCobro()
        {
            int opcionDeBusqueda;
            try
            {
                opcionDeBusqueda = (int)HttpContext.Current.Session["opcionDeBusqueda"];
            }
            catch (NullReferenceException ex)
            {
                opcionDeBusqueda = -1;
            }

            // Opcion propiedades de propietario por nombre
            if (opcionDeBusqueda == 1)
            {
                string numFinca = (string)HttpContext.Current.Session["numFinca"];
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
            else
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                    {
                        string procedure = getConceptosDeCobroSPname;

                        SqlCommand cmd = new SqlCommand(procedure, conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add(new SqlParameter("@inId", DBNull.Value));

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

        protected void GridConceptosDeCobro_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            GridViewRow row = GridConceptosDeCobro.Rows[e.RowIndex];
            Label tb = (Label)row.FindControl("labelId");
            string id = tb.Text;

            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                {
                    string procedure = deleteConceptoDeCobro;
                    SqlCommand cmd = new SqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@inId", SqlDbType.Int).Value = id;

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();
                }
                fillGridConceptoDeCobro();
            }
            catch (SqlException ex)
            {
                string alertMessage = Utilidad.mensajeAlerta(ex);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + alertMessage + "')", true);
            }

        }
    }
}