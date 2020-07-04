using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PrograBases.WebPages
{
    public partial class tablaUsuarios : System.Web.UI.Page
    {
        private string verUsuariosSpName = "SP_UsuarioSelect";
        private string deleteUsuarioSpName = "SP_UsuarioDelete";
        private string insertUsuarioSpName = "SP_UsuarioInsert";
        private string updateUsuarioSpName = "SP_UsuarioUpdate";
        private string verUsuariosDePropiedadSpName = "SP_getUsersOfProperty";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string all = Request.QueryString["all"];
                if (all == "true")
                    HttpContext.Current.Session["opcionDeBusqueda"] = -1;
                fillGridUsuarios();
                //call the function to load initial data into controls....
            }
        }

        private void fillGridUsuarios()
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
                        string procedure = verUsuariosDePropiedadSpName;
                        SqlCommand cmd = new SqlCommand(procedure, conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add("@inNumFinca", SqlDbType.VarChar).Value = numFinca;

                        cmd.Connection = conn;
                        conn.Open();

                        GridUsuarios.DataSource = cmd.ExecuteReader();
                        GridUsuarios.DataBind();
                        GridUsuarios.Visible = true;
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
                        string procedure = verUsuariosSpName;

                        SqlCommand cmd = new SqlCommand(procedure, conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add(new SqlParameter("@inUsuario", DBNull.Value));

                        cmd.Connection = conn;
                        conn.Open();

                        GridUsuarios.DataSource = cmd.ExecuteReader();
                        GridUsuarios.DataBind();
                        GridUsuarios.Visible = true;
                    }

                }
                catch (SqlException ex)
                {
                    string alertMessage = Utilidad.mensajeAlerta(ex);
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + alertMessage + "')", true);

                }
            }
        }

        protected void GridUsuarios_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            GridViewRow row = GridUsuarios.Rows[e.RowIndex];
            Label tb = (Label)row.FindControl("labelUsuario");
            string usuario = tb.Text;

            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                {
                    string procedure = deleteUsuarioSpName;
                    SqlCommand cmd = new SqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@inUsuario", SqlDbType.VarChar).Value = usuario;
                    cmd.Parameters.Add("@inUsuarioACargo", SqlDbType.VarChar).Value = Session["userName"];
                    cmd.Parameters.Add("@inIPusuario", SqlDbType.VarChar).Value = Session["userIp"];

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();
                }
                fillGridUsuarios();
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
            Label tb = (Label)row.FindControl("labelUsuario");
            string nombreUsuario = tb.Text;
            HttpContext.Current.Session["opcionDeBusqueda"] = 3;
            HttpContext.Current.Session["nombreUsuario"] = nombreUsuario;
            Response.Redirect("~/WebPages/Admin/tablaPropiedades.aspx");
        }

        protected void lnkAddGridUsuarios_Click(object sender, EventArgs e)
        {

            GridViewRow row = GridUsuarios.FooterRow;
            TextBox tb = (TextBox)row.FindControl("txtNewUsuario");
            string usuario = (tb.Text).Trim();
            if (String.IsNullOrEmpty(usuario)) usuario = "-1";

            tb = (TextBox)row.FindControl("txtNewPass");
            string pass = (tb.Text).Trim();
            if (String.IsNullOrEmpty(pass)) pass = "-1";

            tb = (TextBox)row.FindControl("txtTipoDeUsuario");
            string tipoUsuario = (tb.Text).Trim();
            if (String.IsNullOrEmpty(tipoUsuario)) tipoUsuario = "-1";

            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                {
                    string procedure = insertUsuarioSpName;
                    SqlCommand cmd = new SqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@inNombre", SqlDbType.VarChar).Value = usuario;
                    cmd.Parameters.Add("@inPassword", SqlDbType.VarChar).Value = pass;
                    cmd.Parameters.Add("@inTipoDeUsuario", SqlDbType.VarChar).Value = tipoUsuario;
                    cmd.Parameters.Add("@inUsuarioACargo", SqlDbType.VarChar).Value = Session["userName"];
                    cmd.Parameters.Add("@inIPusuario", SqlDbType.VarChar).Value = Session["userIp"];

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();
                }
                fillGridUsuarios();
            }
            catch (SqlException ex)
            {
                string alertMessage = Utilidad.mensajeAlerta(ex);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + alertMessage + "')", true);
            }

        }

        protected void botonUpdate_usuario_Click(object sender, EventArgs e)
        {
            string usuario = (usuario_txtForUpdate.Text).Trim();
            string newUsuario = (newUsuario_txtForUpdate.Text).Trim();
            string newPassword = (newPassword_TxtForUpdate.Text).Trim();
            string tipoUsuario = newTipoUsuario_DllForUpdate.SelectedValue;
            if (String.IsNullOrEmpty(usuario)) usuario = "-1";
            if (String.IsNullOrEmpty(newUsuario)) newUsuario = "-1";
            if (String.IsNullOrEmpty(newPassword)) newPassword = "-1";

            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                {
                    string procedure = updateUsuarioSpName;
                    SqlCommand cmd = new SqlCommand(procedure, conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@inNombre ", SqlDbType.VarChar).Value = newUsuario;
                    cmd.Parameters.Add("@inPassword ", SqlDbType.VarChar).Value = newPassword;
                    cmd.Parameters.Add("@inNombreOriginal ", SqlDbType.VarChar).Value = usuario;
                    cmd.Parameters.Add("@inTipoDeUsuario ", SqlDbType.VarChar).Value = tipoUsuario;

                    cmd.Parameters.Add("@inUsuarioACargo", SqlDbType.VarChar).Value = Session["userName"];
                    cmd.Parameters.Add("@inIPusuario", SqlDbType.VarChar).Value = Session["userIp"];

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();
                }
                fillGridUsuarios();
            }
            catch (SqlException ex)
            {
                string alertMessage = Utilidad.mensajeAlerta(ex);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + alertMessage + "')", true);
            }
        }
    }
}