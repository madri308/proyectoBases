<%@ Page Title="" Language="C#" MasterPageFile="~/WebPages/Admin/Admin_Site.master" AutoEventWireup="true" CodeBehind="tablaUsuarios.aspx.cs" Inherits="PrograBases.WebPages.tablaUsuarios" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="/css/Admin/tablaUsuarios.css" type="text/css" media="screen" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="divUsuarios">
         <asp:GridView runat="server" CssClass="gridAdmin" id="GridUsuarios" AutoGenerateColumns="false" Visible="false" ShowFooter="True" CellPadding="3" OnRowDeleting="GridUsuarios_RowDeleting">
            <Columns>
                <asp:TemplateField HeaderText="Usuario" > 
                        <FooterTemplate>
                            <asp:TextBox ID="txtNewUsuario" runat="server" ></asp:TextBox>
                        </FooterTemplate> 
                        <ItemTemplate> 
                            <asp:Label ID="labelUsuario" runat="server" Text='<%# Bind("nombre") %>'></asp:Label>
                        </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Contraseña" > 
                        <FooterTemplate>
                            <asp:TextBox ID="txtNewPass" runat="server" ></asp:TextBox>
                        </FooterTemplate> 
                        <ItemTemplate> 
                            <asp:Label ID="labelPass" runat="server" Text='<%# Bind("password") %>'></asp:Label>
                        </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Tipo de Usuario" > 
                        <FooterTemplate>
                            <asp:TextBox ID="txtTipoDeUsuario" runat="server" ></asp:TextBox>
                        </FooterTemplate> 
                        <ItemTemplate> 
                            <asp:Label ID="labelTipoDeUsuario" runat="server" Text='<%# Bind("tipoDeUsuario") %>'></asp:Label>
                        </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Fecha de Ingreso" > 
                        <ItemTemplate> 
                            <asp:Label ID="labelFechaIngreso" runat="server" Text='<%# Bind("fechaDeIngreso") %>'></asp:Label>
                        </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Propiedades" ShowHeader="False">
                    <FooterTemplate> 
                        <asp:LinkButton ID="lnkAddGridUsuarios" runat="server" CausesValidation="True" CommandName="Insert" Text="Insertar" OnClick="lnkAddGridUsuarios_Click"></asp:LinkButton> 
                    </FooterTemplate>
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkbVerPropiedades" runat="server" CausesValidation="True" OnClick="lnkbVerPropiedades_Click" Text="Ver propiedades"></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:CommandField HeaderText="Borrar" ShowDeleteButton="True" ShowHeader="True" /> 
            </Columns>

             <HeaderStyle BackColor="#222222" Font-Bold="True" ForeColor="White" HorizontalAlign="Center" />
        </asp:GridView>

        <div id="divUpdateUsuarios">
            <asp:Label runat="server" CssClass="updateUsuario_label" ID="usuario_labelForUpdate" Text="Nombre de usuario actual: " AssociatedControlID="usuario_txtForUpdate"  EnableViewState="False">
                <asp:TextBox runat="server" CssClass="updateUsuario_txt" ID="usuario_txtForUpdate"></asp:TextBox>
            </asp:Label>
            <asp:Label runat="server" CssClass="updateUsuario_label" ID="newUsuario_labelForUpdate" Text="Nuevo nombre de usuario: " AssociatedControlID="newUsuario_txtForUpdate"  EnableViewState="False">
                <asp:TextBox runat="server" CssClass="updateUsuario_txt" ID="newUsuario_txtForUpdate"></asp:TextBox>
            </asp:Label>
            <asp:Label runat="server" CssClass="updateUsuario_label" ID="newPassword_labelForUpdate" Text="Nueva contraseña: " AssociatedControlID="newPassword_TxtForUpdate"  EnableViewState="False">
                <asp:TextBox runat="server" CssClass="updateUsuario_txt" ID="newPassword_TxtForUpdate"></asp:TextBox>
            </asp:Label>
            <asp:Label runat="server" CssClass="updateUsuario_label" ID="newtipoUsuario_labelForUpdate" Text="Nuevo tipo de usuario:" AssociatedControlID="newTipoUsuario_DllForUpdate"  EnableViewState="False">
                <asp:DropDownList runat="server" id="newTipoUsuario_DllForUpdate" CssClass="updateUsuario_txt" AutoPostBack="false">
                    <asp:ListItem Value="-1"> No actualizar </asp:ListItem>
                    <asp:ListItem Value="administrador"> Administrador </asp:ListItem>
                    <asp:ListItem Value="normal"> Normal </asp:ListItem>
                </asp:DropDownList>
            </asp:Label>

            <asp:Button runat="server" CssClass="botonUpdate_" Text="Realizar cambio" id="botonUpdate_usuario" OnClick="botonUpdate_usuario_Click"/>
        </div>
    </div>
</asp:Content>
