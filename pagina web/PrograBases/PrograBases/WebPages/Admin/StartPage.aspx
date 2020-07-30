<%@ Page Title="" Language="C#" MasterPageFile="~/WebPages/Admin/Admin_Site.master" AutoEventWireup="true" CodeBehind="StartPage.aspx.cs" Inherits="PrograBases.WebPages.StartPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link rel="stylesheet" href="/css/Admin/StartPage.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="/css/jquery-ui.min.css">
    <script src="/Js/jquery-3.5.1.min.js" type="text/javascript"></script>
    <script src="/Js/jquery-ui.min.js" type="text/javascript"></script>

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

        <div>
            <asp:DropDownList runat="server" id="tipoEntidadConsultaCambios" CssClass="dropDownListStartPage" AutoPostBack="false">
                <asp:ListItem Selected="True" Value="1"> Propiedad </asp:ListItem>
                <asp:ListItem Value="2"> Propietario </asp:ListItem>
                <asp:ListItem Value="3"> Usuario </asp:ListItem>
                <asp:ListItem Value="4"> Propiedad vs Propietario </asp:ListItem>
                <asp:ListItem Value="5"> Propiedad vs Usuario </asp:ListItem>
            </asp:DropDownList>

            <p style="color:white">Fecha inicio: </p>
            <input type="text" name="fromDate" id="fromDate1" />
            <p style="color:white">Fecha final: </p>
            <input type="text" name="toDate" id="toDate1" />

            <asp:Button runat="server" CssClass="botonConsulta" ID="botonConsultaCambiosEnEntidad" Text="Realizar consulta" OnClick="botonConsultaCambiosEnEntidad_Click"/>
        </div>
            
        <div>
            <asp:TextBox runat="server" CssClass="textBoxConsulta" ID="textBoxImpersonarUsuario"></asp:TextBox>
            <asp:Button runat="server" CssClass="botonConsulta" ID="botonImpersonarUsuario" Text="Impersonar Usuario" Onclick="botonImpersonarUsuario_Click" />
        </div>

    </div>

    <script>
        $(function () {
            var from = $("#fromDate1")
                .datepicker({
                    dateFormat: "yy-mm-dd",
                    changeMonth: true
                })
                .on("change", function () {
                    to.datepicker("option", "minDate", getDate(this));
                }),
                to = $("#toDate1").datepicker({
                    dateFormat: "yy-mm-dd",
                    changeMonth: true
                })
                    .on("change", function () {
                        from.datepicker("option", "maxDate", getDate(this));
                    });
        });
    </script>
</asp:Content>
