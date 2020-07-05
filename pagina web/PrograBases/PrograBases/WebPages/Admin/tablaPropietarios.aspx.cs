using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace PrograBases.WebPages
{
    public partial class tablaPropietarios : System.Web.UI.Page
    {
        private string verPropietariosSpName = "SP_PropietarioSelect";
        private string verPropietariosDePropiedadSpName = "SP_getOwnerOfProperty";
        private string propietarioUpdate = "SP_PropietarioUpdate";
        private string propietarioDelete = "SP_PropietarioDelete";
        private string propietarioInsert = "SP_PropietarioInsert";
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                string all = Request.QueryString["all"];
                if (all == "true")
                    HttpContext.Current.Session["opcionDeBusqueda"] = -1;
                fillGridPropietarios();
            }
        }
        // Funciones de la tabla de propietarios ##########################

        protected void fillGridPropietarios()
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
            if (opcionDeBusqueda == 1)
            {
                string numFinca = (string)HttpContext.Current.Session["numFinca"];

                try
                {
                    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                    {
                        string procedure = verPropietariosDePropiedadSpName;
                        SqlCommand cmd = new SqlCommand(procedure, conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add("@inNumFinca", SqlDbType.VarChar).Value = numFinca;

                        cmd.Connection = conn;
                        conn.Open();

                        GridPropietarios.DataSource = cmd.ExecuteReader();
                        GridPropietarios.DataBind();
                        GridPropietarios.Visible = true;
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
                        string procedure = verPropietariosSpName;
                        SqlCommand cmd = new SqlCommand(procedure, conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add(new SqlParameter("@inIdentificacion", DBNull.Value));

                        cmd.Connection = conn;
                        conn.Open();

                        GridPropietarios.DataSource = cmd.ExecuteReader();
                        GridPropietarios.DataBind();
                        GridPropietarios.Visible = true;
                    }

                }
                catch (SqlException ex)
                {
                    string alertMessage = Utilidad.mensajeAlerta(ex);
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + alertMessage + "')", true);

                }
            }
        }
        protected void GridPropietarios_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            GridViewRow row = GridPropietarios.Rows[e.RowIndex];
            Label tb = (Label)row.FindControl("labelBoxIdentificacion");
            string identificacion = tb.Text;
            if (String.IsNullOrEmpty(identificacion))
                identificacion = "-1";
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                {
                    string procedure = propietarioDelete;
                    SqlCommand cmd = new SqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@inIdentificacion", SqlDbType.VarChar).Value = identificacion;
                    cmd.Parameters.Add("@inUsuarioACargo", SqlDbType.VarChar).Value = Session["userName"];
                    cmd.Parameters.Add("@inIPusuario", SqlDbType.VarChar).Value = Session["userIp"];

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();
                }
                fillGridPropietarios();
            }
            catch (SqlException ex)
            {
                string alertMessage = Utilidad.mensajeAlerta(ex);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + alertMessage + "')", true);

            }

        }

        protected void lnkbVerPropiedades_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            // Se obtiene el id
            Label tb = (Label)row.FindControl("labelBoxIdentificacion");
            string idPropietario = tb.Text;
            HttpContext.Current.Session["opcionDeBusqueda"] = 2;
            HttpContext.Current.Session["idPropietario"] = idPropietario;
            Response.Redirect("~/WebPages/Admin/tablaPropiedades.aspx");
        }

        protected void lnkAddGridPropietarios_Click(object sender, EventArgs e)
        {
            GridViewRow row = GridPropietarios.FooterRow;
            TextBox tb = (TextBox)row.FindControl("textBoxNuevoNombrePropietario");
            string nombrePropietario = Utilidad.verificarString_nombres(tb.Text);

            tb = (TextBox)row.FindControl("textBoxNuevoIdTipoId");
            int idTipoId;
            bool success = int.TryParse(tb.Text, out idTipoId);
            if (!success) idTipoId = -1;
            
            tb = (TextBox)row.FindControl("textBoxNuevoIdentificacion");
            string identificacion = (tb.Text).Trim();
            if (String.IsNullOrEmpty(identificacion)) identificacion = "-1";

            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                {
                    string procedure = propietarioInsert;
                    SqlCommand cmd = new SqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@inNombre", SqlDbType.VarChar).Value = nombrePropietario;
                    cmd.Parameters.Add("@inValorDocId", SqlDbType.Int).Value = idTipoId;
                    cmd.Parameters.Add("@inIdentificacion", SqlDbType.VarChar).Value = identificacion;
                    cmd.Parameters.Add("@inUsuarioACargo", SqlDbType.VarChar).Value = Session["userName"];
                    cmd.Parameters.Add("@inIPusuario", SqlDbType.VarChar).Value = Session["userIp"];

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();
                }
                fillGridPropietarios();
            }
            catch (SqlException ex)
            {
                string alertMessage = Utilidad.mensajeAlerta(ex);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + alertMessage + "')", true);
            }
        }

        protected void botonUpdate_propietario_Click(object sender, EventArgs e)
        {
            string identificacionActual = (identificacion_txtForUpdate.Text).Trim();
            string newIdentificacion = (newIdentificacion_txtForUpdate.Text).Trim();
            if (String.IsNullOrEmpty(identificacionActual)) identificacionActual = "-1";
            if (String.IsNullOrEmpty(newIdentificacion)) newIdentificacion = "-1";
            int tipoDocId;
            bool success = int.TryParse(newTipoDocIdP_txtForUpdate.Text, out tipoDocId);
            if (!success) tipoDocId = -1;
            string newName = Utilidad.verificarString_nombres(newName_txtForUpdate.Text);

            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                {
                    string procedure = propietarioUpdate;
                    SqlCommand cmd = new SqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@inNombre", SqlDbType.VarChar).Value = newName;
                    cmd.Parameters.Add("@inValorDocId", SqlDbType.Int).Value = tipoDocId;
                    cmd.Parameters.Add("@inIdentificacion", SqlDbType.VarChar).Value = newIdentificacion;
                    cmd.Parameters.Add("@inIdentificacionOriginal", SqlDbType.VarChar).Value = identificacionActual;
                    cmd.Parameters.Add("@inUsuarioACargo", SqlDbType.VarChar).Value = Session["userName"];
                    cmd.Parameters.Add("@inIPusuario", SqlDbType.VarChar).Value = Session["userIp"];

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();
                }
                fillGridPropietarios();
            }
            catch (SqlException ex)
            {
                string alertMessage = Utilidad.mensajeAlerta(ex);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + alertMessage + "')", true);
            }
        }
    }
}