<%@ Page Title="" Language="C#" MasterPageFile="~/WebPages/Admin/Admin_Site.master" AutoEventWireup="true" CodeBehind="tablaPropietarios.aspx.cs" Inherits="PrograBases.WebPages.tablaPropietarios" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link rel="stylesheet" href="/css/Admin/tablaPropietarios.css" type="text/css" media="screen" />

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div id="divPropietarios">
        <asp:GridView runat="server" id="GridPropietarios" CssClass="gridAdmin" AutoGenerateColumns="false" Visible="false" ShowFooter="True" CellPadding="3" OnRowDeleting="GridPropietarios_RowDeleting">
            <Columns>
                <asp:TemplateField HeaderText="Nombre"> 
                    <FooterTemplate>
                        <asp:TextBox ID="textBoxNuevoNombrePropietario" runat="server" ></asp:TextBox>
                    </FooterTemplate> 
                    <ItemTemplate>
                        <asp:Label ID="labelNombrePropietario" runat="server" Text='<%# Bind("nombre") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Id del tipo de id" >
                    <FooterTemplate>
                        <asp:TextBox ID="textBoxNuevoIdTipoId" runat="server"></asp:TextBox>
                    </FooterTemplate>
                    <ItemTemplate>
                        <asp:Label ID="labelBoxIdTipoId" runat="server" Text='<%# Bind("valorDocId") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Identificacion" >
                    <FooterTemplate>
                        <asp:TextBox ID="textBoxNuevoIdentificacion" runat="server"></asp:TextBox>
                    </FooterTemplate>
                    <ItemTemplate>
                        <asp:Label ID="labelBoxIdentificacion" runat="server" Text='<%# Bind("identificacion") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Propiedad" ShowHeader="False">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkbVerPropiedades" runat="server" CausesValidation="True" OnClick="lnkbVerPropiedades_Click" Text="Ver propiedades"></asp:LinkButton>
                    </ItemTemplate>
                    <FooterTemplate> 
                        <asp:LinkButton ID="lnkAddGridPropietarios" runat="server" CausesValidation="False" CommandName="Insert" Text="Insertar" OnClick="lnkAddGridPropietarios_Click"></asp:LinkButton> 
                    </FooterTemplate>
                </asp:TemplateField>

                <asp:CommandField HeaderText="Borrar" ShowDeleteButton="True" ShowHeader="True" />
            </Columns>
            <HeaderStyle BackColor="#222222" Font-Bold="True" ForeColor="White" HorizontalAlign="Center" />
        </asp:GridView>
        <div id="divUpdatePropietario">
            <asp:Label runat="server" CssClass="updatePropietario_label" ID="identificacion_labelForUpdate" Text="Identificacion actual: " AssociatedControlID="identificacion_txtForUpdate"  EnableViewState="False">
                <asp:TextBox runat="server" CssClass="updatePropietario_txt" ID="identificacion_txtForUpdate"></asp:TextBox>
            </asp:Label>
            <asp:Label runat="server" CssClass="updatePropietario_label" ID="newIdentificacion_labelForUpdate" Text="Nueva identificacion: " AssociatedControlID="newIdentificacion_txtForUpdate"  EnableViewState="False">
                <asp:TextBox runat="server" CssClass="updatePropietario_txt" ID="newIdentificacion_txtForUpdate"></asp:TextBox>
            </asp:Label>
            <asp:Label runat="server" CssClass="updatePropietario_label" ID="newTipoDocIdP_labelForUpdate" Text="Nuevo tipo de identificacion: " AssociatedControlID="newTipoDocIdP_txtForUpdate"  EnableViewState="False">
                <asp:TextBox runat="server" CssClass="updatePropietario_txt" ID="newTipoDocIdP_txtForUpdate"></asp:TextBox>
            </asp:Label>
            <asp:Label runat="server" CssClass="updatePropietario_label" ID="newName_labelForUpdate" Text="Nuevo nombre:" AssociatedControlID="newName_txtForUpdate"  EnableViewState="False">
                <asp:TextBox runat="server" CssClass="updatePropietario_txt" ID="newName_txtForUpdate"></asp:TextBox>
            </asp:Label>

            <asp:Button runat="server" CssClass="botonUpdate_" Text="Realizar cambio" id="botonUpdate_propietario" OnClick="botonUpdate_propietario_Click"/>
        </div>
    </div>

</asp:Content>
