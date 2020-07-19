<%@ Page Title="" Language="C#" MasterPageFile="~/WebPages/Admin/Admin_Site.master" AutoEventWireup="true" CodeBehind="tablaPropiedades.aspx.cs" Inherits="PrograBases.WebPages.tablaPropiedades" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="/css/Admin/tablaPropiedades.css" type="text/css" media="screen" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id ="flexBoxPropiedadesContainer">
        <div id="wrap-Table">
            <table border="1" id="tableHeader">
                <thead>
				    <tr class="row100 head">
					    <th class="cell100 column1" style="width:14%">Numero de Finca</th>
					    <th class="cell100 column2" style="width:15%">Valor</th>
					    <th class="cell100 column3" style="width:25%">Direccion</th>
					    <th class="cell100 column4" style="width:10%">Propietarios</th>
					    <th class="cell100 column5" style="width:10%">Borrar</th>
				    </tr>
			    </thead>        
            </table>

            <div id="divPropiedades" >
                <asp:GridView runat="server" CssClass="gridAdmin" id="GridPropiedades" AutoGenerateColumns="false" Visible="false" ShowFooter="true" ShowHeader="false" CellPadding="3" DataKeyNames="numFinca" OnRowDeleting="GridPropiedades_RowDeleting">
                    <Columns>
                        <asp:TemplateField HeaderText="Numero de Finca" > 
                            <FooterTemplate>
                                <asp:TextBox ID="txtNewNumeroFinca" runat="server" ></asp:TextBox>
                            </FooterTemplate> 
                            <ItemTemplate> 
                                <asp:Label ID="labelNumeroFinca" runat="server" Text='<%# Bind("numFinca") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle Width="10%"/>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Valor"> 
                            <FooterTemplate>
                                <asp:TextBox ID="txtNewValor" runat="server" ></asp:TextBox>
                            </FooterTemplate> 
                            <ItemTemplate> 
                                <asp:Label ID="labelValor" runat="server" Text='<%# "$" + Eval("valor") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle Width="10%"/>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Direccion"> 
                            <FooterTemplate>
                                <asp:TextBox ID="txtNewDireccion" runat="server" ></asp:TextBox>
                            </FooterTemplate> 
                            <ItemTemplate> 
                                <asp:Label ID="labelDireccion" runat="server" Text='<%# Bind("direccion") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle Width="25%"/>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Propietarios" ShowHeader="False">
                            <FooterTemplate> 
                                <asp:LinkButton ID="lnkAddGridPropiedades" runat="server" CausesValidation="True" CommandName="Insert" Text="Insertar" OnClick="lnkAddGridPropiedades_Click"></asp:LinkButton> 
                            </FooterTemplate>
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkbVerPropietarios" runat="server" CausesValidation="True" OnClick="lnkbVerPropietarios_Click" Text="Ver propietarios"></asp:LinkButton>
                                <asp:LinkButton ID="lnkvVerConceptosDeCobro" runat="server" CausesValidation="True" OnClick="lnkvVerConceptosDeCobro_Click" Text="Conceptos de cobro"></asp:LinkButton>
                            </ItemTemplate>
                            <ItemStyle Width="10%"/>
                        </asp:TemplateField>

                        <asp:CommandField HeaderText="Borrar" ShowDeleteButton="True" ShowHeader="True" ItemStyle-Width="10%"/>
                
                    </Columns>
                    <HeaderStyle BackColor="#222222" Font-Bold="True" ForeColor="White" HorizontalAlign="Center" />

                </asp:GridView>   
            </div>
        </div>
        
        <div id="divUpdatePropiedad">
            <asp:Label runat="server" CssClass="updatePropiedad_label" ID="numFinca_labelForUpdate" Text="Numero de finca actual: " AssociatedControlID="numFinca_txtForUpdate"  EnableViewState="False">
                <asp:TextBox runat="server" CssClass="updatePropiedad_txt" ID="numFinca_txtForUpdate"></asp:TextBox>
            </asp:Label>

            <asp:Label runat="server" CssClass="updatePropiedad_label" ID="newNumFinca_labelForUpdate" Text="Nuevo numero de finca: " AssociatedControlID="newNumFinca_txtForUpdate"  EnableViewState="False">
                <asp:TextBox runat="server" CssClass="updatePropiedad_txt" ID="newNumFinca_txtForUpdate"></asp:TextBox>
            </asp:Label>

            <asp:Label runat="server" CssClass="updatePropiedad_label" ID="newValor_labelForUpdate" Text="Nuevo valor: " AssociatedControlID="newValor_txtForUpdate" EnableViewState="False"></asp:Label>
            <asp:TextBox runat="server" CssClass="updatePropiedad_txt" ID="newValor_txtForUpdate"></asp:TextBox>

            <asp:Label runat="server" CssClass="updatePropiedad_label" ID="newDireccion_labelForUpdate" Text="Nueva direccion: " AssociatedControlID="newDireccion_txtForUpdate" EnableViewState="False">
                <asp:TextBox runat="server" CssClass="updatePropiedad_txt" ID="newDireccion_txtForUpdate"></asp:TextBox>
            </asp:Label>

            <asp:Button runat="server" CssClass="botonUpdate_" Text="Realizar cambio" id="botonUpdate_Propiedad" OnClick="botonUpdate_Propiedad_Click"/>
        </div>
    
    </div>

</asp:Content>
