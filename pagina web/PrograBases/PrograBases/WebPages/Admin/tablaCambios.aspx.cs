using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PrograBases.WebPages.Admin
{
    public partial class tablaCambios : System.Web.UI.Page
    {
        private string selectCambiosSPName = "SP_BitacoraSelect";
        private static Dictionary<string, List<string[]>> cambiosPorFecha;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                cambiosPorFecha = new Dictionary<string, List<string[]>> ();
                fillGridCambios();
            }
        }
        protected void fillGridCambios()
        {
            string tipoEntidad = (string)Session["tipoEntidad"];
            string fromDate = (string)Session["fromDate"];
            string toDate = (string)Session["toDate"];
            if (String.IsNullOrEmpty(fromDate)) fromDate = "-1";
            if (String.IsNullOrEmpty(toDate)) toDate = "-1";

            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                {
                    string procedure = selectCambiosSPName;
                    SqlCommand cmd = new SqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@inFechaDesde", SqlDbType.VarChar).Value = fromDate;
                    cmd.Parameters.Add("@inFechaHasta", SqlDbType.VarChar).Value = toDate;
                    cmd.Parameters.Add("@inIdEntidad", SqlDbType.VarChar).Value = tipoEntidad;

                    conn.Open();
                    
                    DataTable newTable = new DataTable();

                    DataColumn col1 = new DataColumn("Fecha De cambio");
                    col1.DataType = System.Type.GetType("System.String");

                    newTable.Columns.Add(col1);

                    DataColumn col2 = new DataColumn("Usuario");
                    col2.DataType = System.Type.GetType("System.String");

                    newTable.Columns.Add(col2);

                    DataColumn col3 = new DataColumn("Ip");
                    col3.DataType = System.Type.GetType("System.String");

                    newTable.Columns.Add(col3);

                    SqlDataReader dr = cmd.ExecuteReader();
                    while (dr.Read())
                    {
                        string fechaCambio = ((DateTime)dr[5]).ToString("dd/MM/yyyy");
                        string JsonAntes = dr[3] == DBNull.Value ? "" : (string)dr[3];
                        string JsonDespues = dr[4] == DBNull.Value ? "" : (string)dr[4];
                        string[] ambosJson = { JsonAntes, JsonDespues};
                        
                        if (cambiosPorFecha.ContainsKey(fechaCambio))
                        {
                            cambiosPorFecha[fechaCambio].Add(ambosJson);
                            continue;
                        }
                        else
                        {
                            cambiosPorFecha[fechaCambio] = new List<string[]> { ambosJson };
                        }
                        DataRow newRow = newTable.NewRow();
                        newRow["Fecha De cambio"] = fechaCambio;
                        newRow["Usuario"] = dr[6];
                        newRow["Ip"] = dr[7];
                        newTable.Rows.Add(newRow);
                    }

                    GridFechas.DataSource = newTable;
                    GridFechas.DataBind();
                    GridFechas.Visible = true;
                }

            }
            catch (SqlException ex)
            {
                string alertMessage = Utilidad.mensajeAlerta(ex);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + alertMessage + "')", true);

            }
        }

        protected void lnkbVerCambiosDeFecha_Click(object sender, EventArgs e)
        {

        }
    }
}