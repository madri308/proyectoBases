using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace PrograBases.WebPages.Normal_user
{
    public partial class tablaRecibos : System.Web.UI.Page
    {
        private string selectRecibosSpName = "SP_RecibosSelect";
        private string selectRecibosDeComprobanteSPName = "SP_ReciboDeComprobanteSelect";
        private string pagarRecibosSPName = "SP_pagarRecibos";
        private string comfirmarPagoSPName = "SP_completarPagoRecibos";
        private string cancelarPagoSPName = "SP_cancelarPagoRecibos";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                fillGridRecibos();
            }
        }

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
                    botonPagarRecibos.Visible = false;
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
                        botonPagarRecibos.Visible = false;
                    }
                }
                catch (SqlException ex)
                {
                    string alertMessage = Utilidad.mensajeAlerta(ex);
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + alertMessage + "')", true);
                }
                
            }
        }

        protected void lnkvVerComprobantesDePago_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            int rowIndex = Convert.ToInt32(row.RowIndex);
            int idRecibo = (int)GridRecibos.DataKeys[rowIndex]["id"];
            Session["idRecibo"] = idRecibo;
            Session["opcionComprobante"] = 1;
            Response.Redirect("~/WebPages/Normal_user/tablaComprobantesDePago.aspx");
        }

        protected void botonPagarRecibos_Click(object sender, EventArgs e)
        {
            labelErrorPagoRecibos.Visible = false;
            DataTable idRecibos = new DataTable();
            HashSet<string> idCCSeleccionados = new HashSet<string>();

            idRecibos.Columns.Add(new DataColumn("id", typeof(int)) { AutoIncrement = true, AutoIncrementSeed = 1, AutoIncrementStep = 1 }) ;
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
                    string procedure = pagarRecibosSPName;

                    SqlCommand cmd = new SqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@inIdRecibos", SqlDbType.Structured).Value = idRecibos;

                    cmd.Connection = conn;
                    conn.Open();

                    GridComfirmacionDePago.DataSource = cmd.ExecuteReader();
                    GridComfirmacionDePago.DataBind();
                    GridComfirmacionDePago.Visible = true;
                }
            }
            catch (SqlException ex)
            {
                string alertMessage = Utilidad.mensajeAlerta(ex);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + alertMessage + "')", true);
                return;
            }
            divTablaConfirmacionDePago.Visible = true;
            decimal total = 0;
            foreach(GridViewRow row in GridComfirmacionDePago.Rows)
            {
                try
                {
                    Label monto = (Label)row.FindControl("labelMonto");
                    total += decimal.Parse(monto.Text);
                }
                catch (FormatException)
                {

                }
            }
            GridViewRow footerRow = GridComfirmacionDePago.FooterRow;
            footerRow.Cells[3].Text = total.ToString();
        }
        protected void botonCancelarPago_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                {
                    string procedure = cancelarPagoSPName;

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
        }
        protected void botonConfirmarPago_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                {
                    string procedure = comfirmarPagoSPName;

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

    }
}