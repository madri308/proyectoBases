using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PrograBases.WebPages.Admin
{
    public partial class usuarioImpersonado : System.Web.UI.Page
    {
        private string verPropiedadesDeUsuario = "SP_getPropertyOfUsers";
        private string selectRecibosSpName = "SP_RecibosSelect";
        private string selectRecibosDeComprobanteSPName = "SP_ReciboDeComprobanteSelect";
        private string getComprobantesDePagoSPName = "SP_ComprobantePagoSelect";
        private string getAllComprobantesDePagoSPName = "SP_ComprobantePagoPorPropiedadSelect";
        private string crearAP = "SP_ConsultarCuota";
        private string comfirmarAP = "SP_CrearAP";
        private string cancelarAP = "SP_cancelarAP";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                fillGridPropiedades();
            }
        }

        // ################ Funciones para propiedades
        protected void fillGridPropiedades()
        {
            string user = (string)Session["nombreDeUsuario"];
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

        // ##################### Funciones para recibos
        protected void fillGridRecibos()
        {
            int opcionRecibosDeComprobante = (int)Session["opcionRecibosDeComprobante"];
            if (opcionRecibosDeComprobante == 1)
            {
                int idComprobante = (int)Session["idComprobante"];
                try
                {
                    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                    {
                        string procedure = selectRecibosDeComprobanteSPName;

                        SqlCommand cmd = new SqlCommand(procedure, conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add("@inIdComprobantePago", SqlDbType.VarChar).Value = idComprobante;

                        cmd.Connection = conn;
                        conn.Open();

                        GridRecibos.DataSource = cmd.ExecuteReader();
                        GridRecibos.DataBind();
                        GridRecibos.Visible = true;
                    }
                    botonCrearAP.Visible = false;
                }
                catch (SqlException ex)
                {
                    string alertMessage = Utilidad.mensajeAlerta(ex);
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + alertMessage + "')", true);
                }
            }
            else
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
                    if (opcionRecibos == 1)
                    {
                        botonCrearAP.Visible = false;
                    }
                }
                catch (SqlException ex)
                {
                    string alertMessage = Utilidad.mensajeAlerta(ex);
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + alertMessage + "')", true);
                }
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

        protected void lnkvVerRecibosPendientes_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            string numfinca = row.Cells[0].Text;
            Session["numFinca"] = numfinca;
            Session["opcionRecibos"] = 0;
            Session["opcionRecibosDeComprobante"] = 0;
            divPropiedades.Visible = false;
            divRecibos.Visible = true;
            fillGridRecibos();
        }

        protected void lnkvVerRecibosPagados_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            string numfinca = row.Cells[0].Text;
            Session["numFinca"] = numfinca;
            Session["opcionRecibos"] = 1;
            Session["opcionRecibosDeComprobante"] = 0;
            divPropiedades.Visible = false;
            divRecibos.Visible = true;
            fillGridRecibos();
        }

        protected void lnkvVerComprobantesDePago_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            string numfinca = row.Cells[0].Text;
            Session["numFinca"] = numfinca;
            Session["opcionComprobante"] = 2;
            fillGridComprobantes();
            divRecibos.Visible = false;
            divPropiedades.Visible = false;
            divComprobantesDePagoContainer.Visible = true;
        }

        protected void lnkvVerRecibosDeComprobante_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            int rowIndex = Convert.ToInt32(row.RowIndex);
            int idComprobante = (int)GridComprobantesDePago.DataKeys[rowIndex]["id"];
            Session["idComprobante"] = idComprobante;
            Session["opcionRecibosDeComprobante"] = 1;
            fillGridRecibos();
            divComprobantesDePagoContainer.Visible = false;
            divRecibos.Visible = true;
        }

        protected void lnkvVerArreglosDePago_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            string numfinca = row.Cells[0].Text;
            Session["numFinca"] = numfinca;
            Response.Redirect("~/WebPages/Admin/tablaAP.aspx");
        }

        // ###################### Funciones para arreglos de pagos
        protected void botonCrearAP_Click(object sender, EventArgs e)
        {
            botonVolverAPropiedades.Visible = false;
            labelErrorPagoRecibos.Visible = false;
            DataTable idRecibos = new DataTable();
            HashSet<string> idCCSeleccionados = new HashSet<string>();

            idRecibos.Columns.Add(new DataColumn("id", typeof(int)) { AutoIncrement = true, AutoIncrementSeed = 1, AutoIncrementStep = 1 });
            idRecibos.Columns.Add("idRecibo", typeof(int));

            for (int rowIndex = GridRecibos.Rows.Count - 1; rowIndex >= 0; rowIndex--)
            {
                GridViewRow row = GridRecibos.Rows[rowIndex];
                string idCC = row.Cells[0].Text;
                CheckBox checkBoxPagar = (CheckBox)row.FindControl("checkBoxRecibo");
                if (checkBoxPagar.Checked)
                {
                    int idRecibo = Convert.ToInt32(GridRecibos.DataKeys[rowIndex]["id"]);
                    DataRow newRow = idRecibos.NewRow();
                    newRow["idRecibo"] = idRecibo;
                    idRecibos.Rows.InsertAt(newRow, 0);
                    idCCSeleccionados.Add(idCC);
                }
                else if (idCCSeleccionados.Contains(idCC))
                {
                    labelErrorPagoRecibos.Visible = true;
                    return;
                }
            }
            if (idRecibos.Rows.Count == 0)
            {
                return;
            }
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                {
                    string procedure = crearAP;

                    SqlCommand cmd = new SqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@inIdRecibos", SqlDbType.Structured).Value = idRecibos;
                    cmd.Parameters.Add("@inMeses", SqlDbType.Int).Value = listaPlazoDeAP.SelectedValue;

                    cmd.Connection = conn;
                    conn.Open();

                    DataTable tablaTemporal = new DataTable();
                    tablaTemporal.Load(cmd.ExecuteReader());
                    DataRow fila = tablaTemporal.Rows[0];

                    Session["cuota"] = fila.ItemArray[0];
                    

                    GridComfirmacionDeAP.DataSource = tablaTemporal;
                    GridComfirmacionDeAP.DataBind();
                    GridComfirmacionDeAP.Visible = true;
                    
                    GridViewRow footerRow = GridComfirmacionDeAP.FooterRow;
                    footerRow.Cells[3].Text = "Cuota: " + Session["cuota"].ToString();
                }
            }
            catch (SqlException ex)
            {
                string alertMessage = Utilidad.mensajeAlerta(ex);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + alertMessage + "')", true);
                return;
            }
            divTablaConfirmacionDePago.Visible = true;
        }

        protected void botonCancelarAP_Click(object sender, EventArgs e)
        {
            botonVolverAPropiedades.Visible = true;
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                {
                    string procedure = cancelarAP;

                    SqlCommand cmd = new SqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();
                }
            }
            catch (SqlException ex)
            {
                string alertMessage = Utilidad.mensajeAlerta(ex);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + alertMessage + "')", true);
            }
            divTablaConfirmacionDePago.Visible = false;
            fillGridRecibos();
        }

        protected void botonConfirmarAP_Click(object sender, EventArgs e)
        {
            botonVolverAPropiedades.Visible = true;
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                {
                    string procedure = comfirmarAP;

                    SqlCommand cmd = new SqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@inMeses", SqlDbType.Int).Value = listaPlazoDeAP.SelectedValue;
                    cmd.Parameters.Add("@inCuota", SqlDbType.Money).Value = (decimal)Session["cuota"];

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();
                }
            }
            catch (SqlException ex)
            {
                string alertMessage = Utilidad.mensajeAlerta(ex);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + alertMessage + "')", true);
            }
            divTablaConfirmacionDePago.Visible = false;
            fillGridRecibos();
        }

        protected void botonVolverAPropiedades_Click(object sender, EventArgs e)
        {
            divComprobantesDePagoContainer.Visible = false;
            divRecibos.Visible = false;
            divPropiedades.Visible = true;
        }
    }
}