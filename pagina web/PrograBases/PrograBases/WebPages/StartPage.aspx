<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="StartPage.aspx.cs" Inherits="PrograBases.WebPages.StartPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link rel="stylesheet" href="/css/StartPage.css" type="text/css" media="screen" />

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div id="divConsultas">
        <div>
            <asp:TextBox runat="server" CssClass="textBoxConsulta" ID="txtPropiedadDePropietario"></asp:TextBox>
            <asp:DropDownList runat="server" id="tipoBusquedaPropietario" CssClass="dropDownListStartPage" AutoPostBack="false">
                <asp:ListItem Selected="True" Value="nombre"> Nombre </asp:ListItem>
                <asp:ListItem Value="identificacion"> Identificacion </asp:ListItem>
            </asp:DropDownList>
            <asp:Button runat="server" CssClass="botonConsulta" Text="Consultar propiedades de propietario" ID="botonConsultaPropiedadDePropietario" OnClick="botonConsultaPropiedadDePropietario_Click"/>
        </div>

        <div>
            <asp:TextBox runat="server" CssClass="textBoxConsulta" ID="txtPropietarioDePropiedad"></asp:TextBox>
            <asp:Button runat="server" CssClass="botonConsulta" Text="Consultar propietario de propiedad" id="botonConsultaPropietarioDePropiedad" OnClick="botonConsultaPropietarioDePropiedad_Click"/>
        </div>
        
        <div>
            <asp:TextBox runat="server" CssClass="textBoxConsulta" ID="txtPropiedadDeUsuario"></asp:TextBox>
            <asp:Button runat="server" CssClass="botonConsulta" ID="botonConsultaPropiedadDeUsuario" Text="Consultar propiedades del usuario" OnClick="botonConsultaPropiedadDeUsuario_Click"/>
        </div>

        <div>
            <asp:TextBox runat="server" CssClass="textBoxConsulta" ID="txtUsuarioDePropiedad"></asp:TextBox>
            <asp:Button runat="server" CssClass="botonConsulta" ID="botonConsultaUsuarioDePropiedad" Text="Consultar usuario de propiedad" OnClick="botonConsultaUsuarioDePropiedad_Click"/>
        </div>
    </div>

</asp:Content>
