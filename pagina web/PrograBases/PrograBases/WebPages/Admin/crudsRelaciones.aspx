<%@ Page Title="" Language="C#" MasterPageFile="~/WebPages/Admin/Admin_Site.master" AutoEventWireup="true" CodeBehind="crudsRelaciones.aspx.cs" Inherits="PrograBases.WebPages.crudsRelaciones" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="/css/Admin/crudsRelaciones.css" type="text/css" media="screen" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div id="divRelaciones">
        <div>
            <p>Propietario de Propiedad</p>
            <asp:Label runat="server" CssClass="relacion_label" ID="numFincaLabel" Text="Numero de finca:" AssociatedControlID="txtNumFinca_propietario"  EnableViewState="False">
                <asp:TextBox runat="server" CssClass="textBoxCruds" ID="txtNumFinca_propietario"></asp:TextBox>
            </asp:Label>
            <asp:Label runat="server" CssClass="relacion_label" ID="labelIdentifiacion" Text="Indentificacion:" AssociatedControlID="txtIdentificacion_propietario"  EnableViewState="False">
                <asp:TextBox runat="server" CssClass="textBoxCruds" ID="txtIdentificacion_propietario"></asp:TextBox>
            </asp:Label>
            <asp:Label runat="server" CssClass="relacion_label" ID="labelDDP_propietario" Text="Accion:" AssociatedControlID="DDLcrudPropiedadPropietario"  EnableViewState="False">
                <asp:DropDownList runat="server" id="DDLcrudPropiedadPropietario" CssClass="dropDownListCRUDS" AutoPostBack="true" OnSelectedIndexChanged="crudPropiedadPropietario_SelectedIndexChanged">
                    <asp:ListItem Value="new"> Nueva Relacion </asp:ListItem>
                    <asp:ListItem Value="delete"> Borrar Relacion </asp:ListItem>
                    <asp:ListItem Value="update"> Actualizar Relacion </asp:ListItem>
                </asp:DropDownList>
            </asp:Label>

            <asp:Label runat="server" CssClass="relacion_label" ID="labelNuevoNumFinca" Text="Nuevo numero de finca:" AssociatedControlID="txtNuevoNumFinca" Visible="false"  EnableViewState="False"></asp:Label>
            <asp:TextBox runat="server" CssClass="textBoxCruds" ID="txtNuevoNumFinca" Visible="false"></asp:TextBox>

            <asp:Label runat="server" CssClass="relacion_label" ID="labelNuevaIndentificacion" Text="Nueva identificacion:" AssociatedControlID="txtNuevaIndentificacion" Visible="false"  EnableViewState="False"></asp:Label>
            <asp:TextBox runat="server" CssClass="textBoxCruds" ID="txtNuevaIndentificacion" Visible="false"></asp:TextBox>
            
            <asp:Button runat="server" CssClass="botonCruds" Text="Realizar cambio" id="botonCrud_propietario" OnClick="botonCrud_propietario_Click"/>
        </div>
        
        <div>
            <p>Usuario de Propiedad</p>
            <asp:Label runat="server" CssClass="relacion_label" ID="labelfinca_usuario" Text="Numero de finca:" AssociatedControlID="txtnumFinca_usuario"  EnableViewState="False">
                <asp:TextBox runat="server" CssClass="textBoxCruds" ID="txtnumFinca_usuario"></asp:TextBox>
            </asp:Label>

            <asp:Label runat="server" CssClass="relacion_label" ID="labelNombre_usuario" Text="Nombre:" AssociatedControlID="txtNombre_usuario"  EnableViewState="False">
                <asp:TextBox runat="server" CssClass="textBoxCruds" ID="txtNombre_usuario"></asp:TextBox>
            </asp:Label>
            <asp:Label runat="server" CssClass="relacion_label" ID="labelDDP_usuario" Text="Accion:" AssociatedControlID="DDPcrudPropiedadUsuario"  EnableViewState="False">
                <asp:DropDownList runat="server" id="DDPcrudPropiedadUsuario" CssClass="dropDownListCRUDS" AutoPostBack="true" OnSelectedIndexChanged="DDPcrudPropiedadUsuario_SelectedIndexChanged">
                    <asp:ListItem Value="new"> Nueva Relacion </asp:ListItem>
                    <asp:ListItem Value="delete"> Borrar Relacion </asp:ListItem>
                    <asp:ListItem Value="update"> Actualizar Relacion </asp:ListItem>
                </asp:DropDownList>
            </asp:Label>

            <asp:Label runat="server" CssClass="relacion_label" ID="labelNuevoNumFinca_usuario" Text="Nuevo numero de finca:" AssociatedControlID="txtNuevoNumFinca_usuario" Visible="false"  EnableViewState="False">
                <asp:TextBox runat="server" CssClass="textBoxCruds" ID="txtNuevoNumFinca_usuario"></asp:TextBox>
            </asp:Label>
            <asp:Label runat="server" CssClass="relacion_label" ID="labelNuevoNombre_usuario" Text="Nuevo usuario:" AssociatedControlID="txtNuevoNombre_usuario" Visible="false"  EnableViewState="False">
                <asp:TextBox runat="server" CssClass="textBoxCruds" ID="txtNuevoNombre_usuario"></asp:TextBox>
            </asp:Label>
            
            <asp:Button runat="server" CssClass="botonCruds" Text="Realizar cambio" id="botonCrud_usuario" OnClick="botonCrud_usuario_Click"/>
        </div>

        <div>
            <p>Conceptos de cobro de una propiedad</p>
            <asp:Label runat="server" CssClass="relacion_label" ID="labelNumFinca_ConceptoDeCobro" Text="Numero de finca:" AssociatedControlID="txtnumFinca_usuario"  EnableViewState="False">
                <asp:TextBox runat="server" CssClass="textBoxCruds" ID="txtNumFinca_ConceptoDeCobro"></asp:TextBox>
            </asp:Label>

            <asp:Label runat="server" CssClass="relacion_label" ID="labelIdCC_ConceptoDeCobro" Text="Id concepto de cobro:" AssociatedControlID="txtNombre_usuario"  EnableViewState="False">
                <asp:TextBox runat="server" CssClass="textBoxCruds" ID="txtIdCC_ConceptoDeCobro"></asp:TextBox>
            </asp:Label>
            <asp:Label runat="server" CssClass="relacion_label" ID="label3" Text="Accion:" AssociatedControlID="DDPcrudConceptoDeCobrosDePropiedad"  EnableViewState="False">
                <asp:DropDownList runat="server" id="DDPcrudConceptoDeCobrosDePropiedad" CssClass="dropDownListCRUDS" AutoPostBack="true" OnSelectedIndexChanged="DDPcrudConceptoDeCobrosDePropiedad_SelectedIndexChanged">
                    <asp:ListItem Value="new"> Nueva Relacion </asp:ListItem>
                    <asp:ListItem Value="delete"> Borrar Relacion </asp:ListItem>
                    <asp:ListItem Value="update"> Actualizar Relacion </asp:ListItem>
                </asp:DropDownList>
            </asp:Label>

            <asp:Label runat="server" CssClass="relacion_label" ID="labelNewNumFinca_ConceptoDeCobro" Text="Nuevo numero de finca:" AssociatedControlID="txtNuevoNumFinca_usuario" Visible="false"  EnableViewState="False">
                <asp:TextBox runat="server" CssClass="textBoxCruds" ID="txtNewNumFinca_ConceptoDeCobro"></asp:TextBox>
            </asp:Label>
            <asp:Label runat="server" CssClass="relacion_label" ID="labelNewIdCC_ConceptoDeCobro" Text="Nuevo id concepto de cobro:" AssociatedControlID="txtNuevoNombre_usuario" Visible="false"  EnableViewState="False">
                <asp:TextBox runat="server" CssClass="textBoxCruds" ID="txtNewIdCC_ConceptoDeCobro"></asp:TextBox>
            </asp:Label>
            
            <asp:Button runat="server" CssClass="botonCruds" Text="Realizar cambio" id="botonCrud_ConceptoDeCobro" OnClick="botonCrud_ConceptoDeCobro_Click"/>
        </div>
    </div>

</asp:Content>
