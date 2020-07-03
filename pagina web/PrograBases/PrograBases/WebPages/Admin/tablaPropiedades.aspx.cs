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
    public partial class tablaPropiedades : System.Web.UI.Page
    {
        private string verPropiedadesSpName = "SP_PropiedadSelect";
        private string verPropiedadesDePropietario = "SP_getPropertyOfOwner";
        private string verPropiedadesDeUsuario = "SP_getPropertyOfUsers";
        private string propiedadDelete = "SP_PropiedadDelete";
        private string propiedadInsert = "SP_PropiedadInsert";
        private string propiedadUpdate = "SP_PropiedadUpdate";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string all = Request.QueryString["all"];
                if (all == "true")
                    HttpContext.Current.Session["opcionDeBusqueda"] = -1;
                fillGridPropiedades();
                //call the function to load initial data into controls....
            }


        }

        protected void fillGridPropiedades()
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
                string nombrePropietario = (string)HttpContext.Current.Session["nombrePropietario"];
                try
                {
                    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                    {
                        string procedure = verPropiedadesDePropietario;

                        SqlCommand cmd = new SqlCommand(procedure, conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add("@inNombre", SqlDbType.VarChar).Value = nombrePropietario;
                        cmd.Parameters.Add(new SqlParameter("@inIdentificacion", DBNull.Value));

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
            else if (opcionDeBusqueda == 2)
            {
                string idPropietario = (string)HttpContext.Current.Session["idPropietario"];
                try
                {
                    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                    {
                        string procedure = verPropiedadesDePropietario;

                        SqlCommand cmd = new SqlCommand(procedure, conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add(new SqlParameter("@inNombre", DBNull.Value));
                        cmd.Parameters.Add("@inIdentificacion", SqlDbType.VarChar).Value = idPropietario;

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
            else if (opcionDeBusqueda == 3)
            {
                string nombreUsuario = (string)HttpContext.Current.Session["nombreUsuario"];
                try
                {
                    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                    {
                        string procedure = verPropiedadesDeUsuario;

                        SqlCommand cmd = new SqlCommand(procedure, conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add("@inUsuario", SqlDbType.VarChar).Value = nombreUsuario;

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
            else
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                    {
                        string procedure = verPropiedadesSpName;

                        SqlCommand cmd = new SqlCommand(procedure, conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add(new SqlParameter("@inNumFinca", DBNull.Value));

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
        }

        protected void GridPropiedades_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            GridViewRow row = GridPropiedades.Rows[e.RowIndex];
            Label tb = (Label)row.FindControl("labelNumeroFinca");
            string numfinca = tb.Text;

            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                {
                    string procedure = propiedadDelete;
                    SqlCommand cmd = new SqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@inNumFinca", SqlDbType.VarChar).Value = numfinca;
                    cmd.Parameters.Add("@inUsuarioACargo", SqlDbType.VarChar).Value = Session["userName"];
                    cmd.Parameters.Add("@inIPusuario", SqlDbType.VarChar).Value = Session["userIp"];

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();
                }
                fillGridPropiedades();
            }
            catch (SqlException ex)
            {
                string alertMessage = Utilidad.mensajeAlerta(ex);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + alertMessage + "')", true);
            }
        }
        protected void lnkAddGridPropiedades_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            TextBox tb = (TextBox)row.FindControl("txtNewNumeroFinca");
            string numfinca = (tb.Text).Trim();
            if (String.IsNullOrEmpty(numfinca)) numfinca = "-1";

            tb = (TextBox)row.FindControl("txtNewValor");
            decimal valor;
            bool success = decimal.TryParse(tb.Text, out valor);
            if (!success) valor = -1;
            
            tb = (TextBox)row.FindControl("txtNewDireccion");
            String direccion = (tb.Text).Trim();
            if (String.IsNullOrEmpty(direccion)) direccion = "-1";
            
            //TODO falta catch
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                {
                    string procedure = propiedadInsert;
                    SqlCommand cmd = new SqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@inNumFinca", SqlDbType.VarChar).Value = numfinca;
                    cmd.Parameters.Add("@inValor", SqlDbType.Money).Value = valor;
                    cmd.Parameters.Add("@inDireccion", SqlDbType.VarChar).Value = direccion;
                    cmd.Parameters.Add("@inUsuarioACargo", SqlDbType.VarChar).Value = Session["userName"];
                    cmd.Parameters.Add("@inIPusuario", SqlDbType.VarChar).Value = Session["userIp"];

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();
                }
                fillGridPropiedades();
            }
            catch (SqlException ex)
            {
                string alertMessage = Utilidad.mensajeAlerta(ex);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + alertMessage + "')", true);
            }
        }

        protected void lnkbVerPropietarios_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            // Se obtiene el id
            Label tb = (Label)row.FindControl("labelNumeroFinca");
            string numfinca = tb.Text;
            HttpContext.Current.Session["opcionDeBusqueda"] = 1;
            HttpContext.Current.Session["numFinca"] = numfinca;
            Response.Redirect("~/WebPages/Admin/tablaPropietarios.aspx");
        }

        protected void botonUpdate_Propiedad_Click(object sender, EventArgs e)
        {
            string numFincaActual = (numFinca_txtForUpdate.Text).Trim();
            string newNumFinca = (newNumFinca_txtForUpdate.Text).Trim();
            if (String.IsNullOrEmpty(numFincaActual)) numFincaActual = "-1";
            if (String.IsNullOrEmpty(newNumFinca)) newNumFinca = "-1";
            decimal newValor;
            bool success = decimal.TryParse(newValor_txtForUpdate.Text, out newValor);
            if (!success) newValor = -1;
            string newDireccion = (newDireccion_txtForUpdate.Text).Trim();
            if (String.IsNullOrEmpty(newDireccion)) newDireccion = "-1";
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                {
                    string procedure = propiedadUpdate;
                    SqlCommand cmd = new SqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@inValor", SqlDbType.Money).Value = newValor;
                    cmd.Parameters.Add("@inDireccion", SqlDbType.VarChar).Value = newDireccion;
                    cmd.Parameters.Add("@inNumFinca", SqlDbType.VarChar).Value = newNumFinca;
                    cmd.Parameters.Add("@inNumFincaOriginal", SqlDbType.VarChar).Value = numFincaActual;
                    cmd.Parameters.Add("@inUsuarioACargo", SqlDbType.VarChar).Value = Session["userName"];
                    cmd.Parameters.Add("@inIPusuario", SqlDbType.VarChar).Value = Session["userIp"];

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();
                }
                fillGridPropiedades();
            }
            catch (SqlException ex)
            {
                string alertMessage = Utilidad.mensajeAlerta(ex);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + alertMessage + "')", true);
            }
        }

        protected void lnkvVerConceptosDeCobro_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            // Se obtiene el id
            Label tb = (Label)row.FindControl("labelNumeroFinca");
            string numfinca = tb.Text;
            HttpContext.Current.Session["opcionDeBusqueda"] = 1;
            HttpContext.Current.Session["numFinca"] = numfinca;
            Response.Redirect("~/WebPages/Admin/tablaConceptosDeCobro.aspx");
        }
    }
}