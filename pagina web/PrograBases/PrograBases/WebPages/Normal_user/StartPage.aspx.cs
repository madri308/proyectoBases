﻿using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PrograBases.WebPages.Normal_user
{
    public partial class StartPage1 : System.Web.UI.Page
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
            string user = (string)Session["userName"];
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

        // ########################## Funciones para recibos
        protected void lnkvVerConceptosDeCobro_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            string numfinca = row.Cells[0].Text;
            Session["numFinca"] = numfinca;
            Response.Redirect("~/WebPages/Normal_user/tablaConceptosDeCobro.aspx");
        }
        protected void lnkvVerRecibosPagados_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            string numfinca = row.Cells[0].Text;
            Session["numFinca"] = numfinca;
            Session["opcionRecibos"] = 1;
            Session["opcionRecibosDeComprobante"] = 0;
            Response.Redirect("~/WebPages/Normal_user/tablaRecibos.aspx");
        }

        protected void lnkvVerRecibosPendientes_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            string numfinca = row.Cells[0].Text;
            Session["numFinca"] = numfinca;
            Session["opcionRecibos"] = 0;
            Session["opcionRecibosDeComprobante"] = 0;
            Response.Redirect("~/WebPages/Normal_user/tablaRecibos.aspx");
        }

        protected void lnkvVerComprobantesDePago_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            string numfinca = row.Cells[0].Text;
            Session["numFinca"] = numfinca;
            Session["opcionComprobante"] = 2;
            Response.Redirect("~/WebPages/Normal_user/tablaComprobantesDePago.aspx");
        }

        protected void lnkvVerArreglosDePago_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            string numfinca = row.Cells[0].Text;
            Session["numFinca"] = numfinca;
            Response.Redirect("~/WebPages/Normal_user/tablaAP.aspx");
        }
    }
}