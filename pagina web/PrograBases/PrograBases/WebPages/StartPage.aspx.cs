﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PrograBases.WebPages
{
    public partial class StartPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        // Consultas relacionadas con propiedades
        protected void botonConsultaPropiedadDePropietario_Click(object sender, EventArgs e)
        {
            string tipoBusqueda = tipoBusquedaPropietario.SelectedValue;
            if (tipoBusqueda == "nombre")
            {
                string nombrePropietario = Utilidad.verificarString_nombres(txtPropiedadDePropietario.Text);
                HttpContext.Current.Session["opcionDeBusqueda"] = 1;
                HttpContext.Current.Session["nombrePropietario"] = nombrePropietario;
                Response.Redirect("~/WebPages/tablaPropiedades.aspx");
            }
            else
            {
                try
                {
                    string idPropietario = (txtPropiedadDePropietario.Text).Trim();
                    if (string.IsNullOrEmpty(idPropietario)) idPropietario = "-1";
                    HttpContext.Current.Session["opcionDeBusqueda"] = 2;
                    HttpContext.Current.Session["idPropietario"] = idPropietario;
                    Response.Redirect("~/WebPages/tablaPropiedades.aspx");
                }
                catch (Exception ex)
                {

                }
            }
        }
        protected void botonConsultaPropiedadDeUsuario_Click(object sender, EventArgs e)
        {
            string nombreUsuario = Utilidad.verificarString_nombres(txtPropiedadDeUsuario.Text);
            HttpContext.Current.Session["opcionDeBusqueda"] = 3;
            HttpContext.Current.Session["nombreUsuario"] = nombreUsuario;
            Response.Redirect("~/WebPages/tablaPropiedades.aspx");
        }

        // Consultas relacionadas con propietarios
        protected void botonConsultaPropietarioDePropiedad_Click(object sender, EventArgs e)
        {
            string numFica = (txtPropietarioDePropiedad.Text).Trim();
            HttpContext.Current.Session["opcionDeBusqueda"] = 1;
            HttpContext.Current.Session["numFinca"] = numFica;
            Response.Redirect("~/WebPages/tablaPropietarios.aspx");
        }

        protected void botonConsultaUsuarioDePropiedad_Click(object sender, EventArgs e)
        {
            //TODO no funciona porque falta grid de usuarios
            string numFica = txtUsuarioDePropiedad.Text;
            HttpContext.Current.Session["opcionDeBusqueda"] = 1;
            HttpContext.Current.Session["numFinca"] = numFica;
            Response.Redirect("~/WebPages/tablaUsuarios.aspx");
        }
    }
}