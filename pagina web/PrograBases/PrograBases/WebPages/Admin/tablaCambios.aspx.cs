using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PrograBases.WebPages.Admin
{
    public partial class tablaCambios : System.Web.UI.Page
    {
        private string selectCambiosSPName = "SP_BitacoraSelect";
        private static Dictionary<string, string[]> cambiosPorFecha;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                cambiosPorFecha = new Dictionary<string, string[]> ();
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
                    int currentIndex = 0;
                    char[] trimChars = { '[', ']' };
                    while (dr.Read())
                    {
                        string fechaCambio = ((DateTime)dr[5]).ToString("dd/MM/yyyy");
                        string JsonAntes = dr[3] == DBNull.Value ? "" : ((string)dr[3]).Trim(trimChars);
                        string JsonDespues = dr[4] == DBNull.Value ? "" : ((string)dr[4]).Trim(trimChars);

                        string[] ambosJson = { JsonAntes, JsonDespues};
                        cambiosPorFecha[currentIndex.ToString()] = ambosJson ;
                        DataRow newRow = newTable.NewRow();
                        newRow["Fecha De cambio"] = fechaCambio;
                        newRow["Usuario"] = dr[6];
                        newRow["Ip"] = dr[7];
                        newTable.Rows.Add(newRow);

                        currentIndex++;
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
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            string rowIndex = (row.RowIndex).ToString();
            string[] ambosJson = cambiosPorFecha[rowIndex];

            Dictionary<string, dynamic> valoresJsonAntes = JsonConvert.DeserializeObject<Dictionary<string, dynamic>>(ambosJson[0]);
            Dictionary<string, dynamic> valoresJsonDespues = JsonConvert.DeserializeObject<Dictionary<string, dynamic>>(ambosJson[1]);

            Dictionary<string, dynamic> jsonNoNulo = valoresJsonAntes is null ? valoresJsonDespues : valoresJsonAntes;

            DataTable newTable = new DataTable();
            List<string> columnas = new List<string>();

            foreach(KeyValuePair<string, dynamic> entry in jsonNoNulo)
            {
                DataColumn col1 = new DataColumn(entry.Key);
                col1.DataType = System.Type.GetType("System.String");
                newTable.Columns.Add(col1);

                columnas.Add(entry.Key);
            }
            int columnaActual = 0;
            if ( valoresJsonAntes != null)
            {
                DataRow newRow = newTable.NewRow();
                foreach(KeyValuePair<string, dynamic> entry in valoresJsonAntes)
                {
                    newRow[columnas.ElementAt(columnaActual)] = entry.Value;
                    columnaActual++;
                }
                newTable.Rows.Add(newRow);

                columnaActual = 0;
            }
            if (valoresJsonDespues != null)
            {
                DataRow newRow2 = newTable.NewRow();
                foreach (KeyValuePair<string, dynamic> entry in valoresJsonDespues)
                {
                    newRow2[columnas.ElementAt(columnaActual)] = entry.Value;
                    columnaActual++;
                }
                newTable.Rows.Add(newRow2);
            }    

            GridJsonAntes.DataSource = newTable;
            GridJsonAntes.DataBind();
            GridJsonAntes.Visible = true;
            GridFechas.Visible = false;
        }

        protected void GridFechas_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            /*
            TableCell cell = e.Row.Cells[0];
            e.Row.Cells.RemoveAt(0);
            e.Row.Cells.Add(cell);
            */
        }
    }
}