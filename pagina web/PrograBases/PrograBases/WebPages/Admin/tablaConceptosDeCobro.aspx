<%@ Page Title="" Language="C#" MasterPageFile="~/WebPages/Admin/Admin_Site.master" AutoEventWireup="true" CodeBehind="tablaConceptosDeCobro.aspx.cs" Inherits="PrograBases.WebPages.tablaConceptosDeCobro" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="/css/Admin/tablaConceptoDeCobro.css" type="text/css" media="screen" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="divConceptoDeCobro">
        <asp:GridView runat="server" CssClass="gridAdmin" id="GridConceptosDeCobro" AutoGenerateColumns="false" Visible="false" ShowFooter="True" CellPadding="3" DataKeyNames="id" OnRowDeleting="GridConceptosDeCobro_RowDeleting">
            <Columns>
                <asp:TemplateField HeaderText="Id">
                    <HeaderStyle Width="10px" />
                    <FooterTemplate>
                        <asp:TextBox ID="txtId" runat="server" ></asp:TextBox>
                    </FooterTemplate> 
                    <ItemTemplate> 
                        <asp:Label ID="labelId" runat="server" Text='<%# Bind("id") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Nombre" > 
                    <FooterTemplate>
                        <asp:TextBox ID="txtNewNombre" runat="server" ></asp:TextBox>
                    </FooterTemplate> 
                    <ItemTemplate> 
                        <asp:Label ID="labelNombre" runat="server" Text='<%# Bind("nombre") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Dias para vencer" > 
                    <FooterTemplate>
                        <asp:TextBox ID="txtDasParaVencer" runat="server" ></asp:TextBox>
                    </FooterTemplate> 
                    <ItemTemplate> 
                        <asp:Label ID="labelDiasParaVencer" runat="server" Text='<%# Bind("diasParaVencer") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Dia De Cobro" > 
                    <FooterTemplate>
                        <asp:TextBox ID="txtDiaDeCobro" runat="server" ></asp:TextBox>
                    </FooterTemplate> 
                    <ItemTemplate> 
                        <asp:Label ID="labelDiaDeCobro" runat="server" Text='<%# Bind("diaDeCobro") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Tasa impuesto moratorio" > 
                    <FooterTemplate>
                        <asp:TextBox ID="txtTasaImpuestoMoratorio" runat="server" ></asp:TextBox>
                    </FooterTemplate> 
                    <ItemTemplate> 
                        <asp:Label ID="labelTasaImpuestoMoratorio" runat="server" Text='<%# Bind("tasaImpuestoMoratorio") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Es impuesto" > 
                    <FooterTemplate>
                        <asp:TextBox ID="txtEsImpuesto" runat="server" ></asp:TextBox>
                    </FooterTemplate> 
                    <ItemTemplate> 
                        <asp:Label ID="labelEsImpuesto" runat="server" Text='<%# Bind("esImpuesto") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Es recurrente" > 
                    <FooterTemplate>
                        <asp:TextBox ID="txtEsRecurrente" runat="server" ></asp:TextBox>
                    </FooterTemplate> 
                    <ItemTemplate> 
                        <asp:Label ID="labelEsRecurrente" runat="server" Text='<%# Bind("esRecurrente") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Es fijo" > 
                    <FooterTemplate>
                        <asp:TextBox ID="txtEsFijo" runat="server" ></asp:TextBox>
                    </FooterTemplate> 
                    <ItemTemplate> 
                        <asp:Label ID="labelEsFijo" runat="server" Text='<%# Bind("esFijo") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Monto" > 
                    <FooterTemplate>
                        <asp:TextBox ID="txtMonto" runat="server" ></asp:TextBox>
                    </FooterTemplate> 
                    <ItemTemplate> 
                        <asp:Label ID="labelMonto" runat="server" Text='<%# Bind("monto") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:CommandField HeaderText="Borrar" ShowDeleteButton="True" ShowHeader="True"/>
            </Columns>
            <HeaderStyle BackColor="#222222" Font-Bold="True" ForeColor="White" HorizontalAlign="Center"/>
        </asp:GridView>
    </div>
</asp:Content>
