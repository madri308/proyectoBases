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

namespace PrograBases.WebPages
{
    public partial class crudsRelaciones : System.Web.UI.Page
    {
        private string addRelacionPropietarioPropiedadSPname = "SP_PropiedadDelPropietarioInsert";
        private string deleteRelacionPropietarioPropiedadSPname = "SP_PropiedadDelPropietarioDelete";
        private string updateRelacionPropietarioPropiedadSPname = "SP_PropiedadDelPropietarioUpdate";
        private string addRelacionUsuarioPropiedadSPname = "SP_UsuarioDePropiedadInsert";
        private string deleteRelacionUsuarioPropiedadSPname = "SP_UsuarioDePropiedadDelete";
        private string updateRelacionUsuarioPropiedadSPname = "SP_UsuarioDePropiedadUpdate";
        private string addCCDePropiedad = "SP_CCDePropiedadInsert";
        private string deleteCCDePropiedad = "SP_CCDePropiedadDelete";
        private string updateCCDePropiedad = "SP_CCDePropiedadUpdate";
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        // CRUDS de propietarios con propiedad
        protected void crudPropiedadPropietario_SelectedIndexChanged(object sender, EventArgs e)
        {
            string tipo = DDLcrudPropiedadPropietario.SelectedValue;
            if (tipo == "update")
            {
                labelNuevoNumFinca.Visible = true;
                labelNuevaIndentificacion.Visible = true;
                txtNuevoNumFinca.Visible = true;
                txtNuevaIndentificacion.Visible = true;
            }
            else
            {
                labelNuevoNumFinca.Visible = false;
                labelNuevaIndentificacion.Visible = false;
                txtNuevoNumFinca.Visible = false;
                txtNuevaIndentificacion.Visible = false;
            }
        }
        protected void botonCrud_propietario_Click(object sender, EventArgs e)
        {
            string crudTipo = DDLcrudPropiedadPropietario.SelectedValue;
            if (crudTipo == "new")
            {
                string numFinca = (txtNumFinca_propietario.Text).Trim();
                string identificacion = (txtIdentificacion_propietario.Text).Trim();
                if (String.IsNullOrEmpty(numFinca)) numFinca = "-1";
                if (String.IsNullOrEmpty(identificacion)) identificacion = "-1";

                try
                {
                    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                    {
                        string procedure = addRelacionPropietarioPropiedadSPname;
                        SqlCommand cmd = new SqlCommand(procedure, conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add("@inNumFinca", SqlDbType.VarChar).Value = numFinca;
                        cmd.Parameters.Add("@inIdentificacion", SqlDbType.VarChar).Value = identificacion;
                        cmd.Parameters.Add("@inUsuarioACargo", SqlDbType.VarChar).Value = Session["userName"];
                        cmd.Parameters.Add("@inIPusuario", SqlDbType.VarChar).Value = Session["userIp"];
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
            }
            else if (crudTipo == "delete")
            {
                string numFinca = (txtNumFinca_propietario.Text).Trim();
                string identificacion = (txtIdentificacion_propietario.Text).Trim();
                if (String.IsNullOrEmpty(numFinca)) numFinca = "-1";
                if (String.IsNullOrEmpty(identificacion)) identificacion = "-1";

                try
                {
                    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                    {
                        string procedure = deleteRelacionPropietarioPropiedadSPname;
                        SqlCommand cmd = new SqlCommand(procedure, conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add("@inNumFinca", SqlDbType.VarChar).Value = numFinca;
                        cmd.Parameters.Add("@inIdentificacion", SqlDbType.VarChar).Value = identificacion;
                        cmd.Parameters.Add("@inUsuarioACargo", SqlDbType.VarChar).Value = Session["userName"];
                        cmd.Parameters.Add("@inIPusuario", SqlDbType.VarChar).Value = Session["userIp"];

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
            }
            else
            {
                string numFinca = (txtNumFinca_propietario.Text).Trim();
                string identificacion = (txtIdentificacion_propietario.Text).Trim();
                string newNumFinca = (txtNuevoNumFinca.Text).Trim();
                string newIdentificacion = (txtNuevaIndentificacion.Text).Trim();
                if (String.IsNullOrEmpty(numFinca)) numFinca = "-1";
                if (String.IsNullOrEmpty(identificacion)) identificacion = "-1";
                if (String.IsNullOrEmpty(newNumFinca)) newNumFinca = "-1";
                if (String.IsNullOrEmpty(newIdentificacion)) newIdentificacion = "-1";
                try
                {
                    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                    {
                        string procedure = updateRelacionPropietarioPropiedadSPname;
                        SqlCommand cmd = new SqlCommand(procedure, conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add("@inIdentificacionOriginal", SqlDbType.VarChar).Value = identificacion;
                        cmd.Parameters.Add("@inIdentificacion", SqlDbType.VarChar).Value = newIdentificacion;
                        cmd.Parameters.Add("@inNumFincaOriginal", SqlDbType.VarChar).Value = numFinca;
                        cmd.Parameters.Add("@inNumFinca", SqlDbType.VarChar).Value = newNumFinca;
                        cmd.Parameters.Add("@inUsuarioACargo", SqlDbType.VarChar).Value = Session["userName"];
                        cmd.Parameters.Add("@inIPusuario", SqlDbType.VarChar).Value = Session["userIp"];

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
            }
        }

        //################## CRUDS de usuarios con propiedad #######################
        protected void DDPcrudPropiedadUsuario_SelectedIndexChanged(object sender, EventArgs e)
        {
            string tipo = DDPcrudPropiedadUsuario.SelectedValue;
            if (tipo == "update")
            {
                labelNuevoNumFinca_usuario.Visible = true;
                labelNuevoNombre_usuario.Visible = true;
                txtNuevoNumFinca_usuario.Visible = true;
                txtNuevoNombre_usuario.Visible = true;
            }
            else
            {
                labelNuevoNumFinca_usuario.Visible = false;
                labelNuevoNombre_usuario.Visible = false;
                txtNuevoNumFinca_usuario.Visible = false;
                txtNuevoNombre_usuario.Visible = false;
            }
        }
        protected void botonCrud_usuario_Click(object sender, EventArgs e)
        {
            string crudTipo = DDPcrudPropiedadUsuario.SelectedValue;
            if (crudTipo == "new")
            {
                string numFinca = (txtnumFinca_usuario.Text).Trim();
                string usuario = (txtNombre_usuario.Text).Trim();
                if (String.IsNullOrEmpty(numFinca)) numFinca = "-1";
                if (String.IsNullOrEmpty(usuario)) usuario = "-1";

                try
                {
                    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                    {
                        string procedure = addRelacionUsuarioPropiedadSPname;
                        SqlCommand cmd = new SqlCommand(procedure, conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add("@inUsuario", SqlDbType.VarChar).Value = usuario;
                        cmd.Parameters.Add("@inNumFinca", SqlDbType.VarChar).Value = numFinca;
                        cmd.Parameters.Add("@inUsuarioACargo", SqlDbType.VarChar).Value = Session["userName"];
                        cmd.Parameters.Add("@inIPusuario", SqlDbType.VarChar).Value = Session["userIp"];

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
            }
            else if (crudTipo == "delete")
            {
                string numFinca = (txtnumFinca_usuario.Text).Trim();
                string usuario = (txtNombre_usuario.Text).Trim();
                if (String.IsNullOrEmpty(numFinca)) numFinca = "-1";
                if (String.IsNullOrEmpty(usuario)) usuario = "-1";

                try
                {
                    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                    {
                        string procedure = deleteRelacionUsuarioPropiedadSPname;
                        SqlCommand cmd = new SqlCommand(procedure, conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add("@inUsuario", SqlDbType.VarChar).Value = usuario;
                        cmd.Parameters.Add("@inNumFinca", SqlDbType.VarChar).Value = numFinca;
                        cmd.Parameters.Add("@inUsuarioACargo", SqlDbType.VarChar).Value = Session["userName"];
                        cmd.Parameters.Add("@inIPusuario", SqlDbType.VarChar).Value = Session["userIp"];

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
            }
            else
            {
                string numFinca = (txtnumFinca_usuario.Text).Trim();
                string usuario = (txtNombre_usuario.Text).Trim();
                string newNumFinca = (txtNuevoNumFinca_usuario.Text).Trim(); ;
                string newUsuario = (txtNuevoNombre_usuario.Text).Trim(); ;
                if (String.IsNullOrEmpty(numFinca)) numFinca = "-1";
                if (String.IsNullOrEmpty(usuario)) usuario = "-1";
                if (String.IsNullOrEmpty(newNumFinca)) newNumFinca = "-1";
                if (String.IsNullOrEmpty(newUsuario)) newUsuario = "-1";
                try
                {
                    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                    {
                        string procedure = updateRelacionUsuarioPropiedadSPname;
                        SqlCommand cmd = new SqlCommand(procedure, conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add("@inNumFinca", SqlDbType.VarChar).Value = newNumFinca;
                        cmd.Parameters.Add("@inUsuario", SqlDbType.VarChar).Value = newUsuario;
                        cmd.Parameters.Add("@inNumFincaOriginal", SqlDbType.VarChar).Value = numFinca;
                        cmd.Parameters.Add("@inUsuarioOriginal", SqlDbType.VarChar).Value = usuario;
                        cmd.Parameters.Add("@inUsuarioACargo", SqlDbType.VarChar).Value = Session["userName"];
                        cmd.Parameters.Add("@inIPusuario", SqlDbType.VarChar).Value = Session["userIp"];

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
            }
        }

        protected void DDPcrudConceptoDeCobrosDePropiedad_SelectedIndexChanged(object sender, EventArgs e)
        {
            string tipo = DDPcrudConceptoDeCobrosDePropiedad.SelectedValue;
            if (tipo == "update")
            {
                labelNewNumFinca_ConceptoDeCobro.Visible = true;
                labelNewIdCC_ConceptoDeCobro.Visible = true;
                txtNewNumFinca_ConceptoDeCobro.Visible = true;
                txtNewIdCC_ConceptoDeCobro.Visible = true;
            }
            else
            {
                labelNewNumFinca_ConceptoDeCobro.Visible = false;
                labelNewIdCC_ConceptoDeCobro.Visible = false;
                txtNewNumFinca_ConceptoDeCobro.Visible = false;
                txtNewIdCC_ConceptoDeCobro.Visible = false;
            }
        }

        protected void botonCrud_ConceptoDeCobro_Click(object sender, EventArgs e)
        {
            string crudTipo = DDPcrudConceptoDeCobrosDePropiedad.SelectedValue;
            if (crudTipo == "new")
            {
                string numFinca = (txtNumFinca_ConceptoDeCobro.Text).Trim();
                int idConceptoDeCobro;
                bool succes = int.TryParse(txtIdCC_ConceptoDeCobro.Text, out idConceptoDeCobro);
                if (String.IsNullOrEmpty(numFinca)) numFinca = "-1";
                if (!succes) idConceptoDeCobro = -1;

                try
                {
                    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                    {
                        string procedure = addCCDePropiedad;
                        SqlCommand cmd = new SqlCommand(procedure, conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add("@inIdcobro", SqlDbType.Int).Value = idConceptoDeCobro;
                        cmd.Parameters.Add("@inNumFinca", SqlDbType.VarChar).Value = numFinca;

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
            }
            else if (crudTipo == "delete")
            {
                string numFinca = (txtNumFinca_ConceptoDeCobro.Text).Trim();
                int idConceptoDeCobro;
                bool succes = int.TryParse(txtIdCC_ConceptoDeCobro.Text, out idConceptoDeCobro);
                if (String.IsNullOrEmpty(numFinca)) numFinca = "-1";
                if (!succes) idConceptoDeCobro = -1;

                try
                {
                    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                    {
                        string procedure = deleteCCDePropiedad;
                        SqlCommand cmd = new SqlCommand(procedure, conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add("@inIdCC", SqlDbType.Int).Value = idConceptoDeCobro;
                        cmd.Parameters.Add("@inNumFinca", SqlDbType.VarChar).Value = numFinca;

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
            }
            else
            {                
                string numFinca = (txtNumFinca_ConceptoDeCobro.Text).Trim();
                string newNumFinca = (txtNewNumFinca_ConceptoDeCobro.Text).Trim(); 
                if (String.IsNullOrEmpty(numFinca)) numFinca = "-1";
                if (String.IsNullOrEmpty(newNumFinca)) newNumFinca = "-1";

                int idConceptoDeCobro;
                int newIdConceptoDeCobro;
                bool succes = int.TryParse(txtIdCC_ConceptoDeCobro.Text, out idConceptoDeCobro);
                if (!succes) idConceptoDeCobro = -1;

                succes = int.TryParse(txtNewIdCC_ConceptoDeCobro.Text, out newIdConceptoDeCobro);
                if (!succes) newIdConceptoDeCobro = -1;

                try
                {
                    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["connDB"].ConnectionString))
                    {
                        string procedure = updateCCDePropiedad;
                        SqlCommand cmd = new SqlCommand(procedure, conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.Add("@inIdCCOrigianl", SqlDbType.Int).Value = idConceptoDeCobro;
                        cmd.Parameters.Add("@inId_CC", SqlDbType.VarChar).Value = newIdConceptoDeCobro;

                        cmd.Parameters.Add("@inNumFincaOriginal", SqlDbType.Int).Value = numFinca;
                        cmd.Parameters.Add("@inNumFinca", SqlDbType.VarChar).Value = newNumFinca;

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
            }
        }
    }   
}