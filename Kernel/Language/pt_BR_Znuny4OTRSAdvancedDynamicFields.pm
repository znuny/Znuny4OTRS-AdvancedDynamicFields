# --
# Copyright (C) 2017 Edicarlos Lopes dos Santos <edicarlos.lds@gmail.com>
# Copyright (C) 2012-2022 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
## nofilter(TidyAll::Plugin::Znuny4OTRS::CodeStyle::TODOCheck)

package Kernel::Language::pt_BR_Znuny4OTRSAdvancedDynamicFields;

use strict;
use warnings;

use utf8;

sub Data {
    my $Self = shift;

    # Import / Export
    # Frontend
    $Self->{Translation}->{'Here you can upload a configuration file to import dynamic fields to your system. The file needs to be in .yml format as exported by dynamic field management module.'} = 'Aqui você pode carregar um arquivo de configuração para importar campos dinâmicos para o seu sistema. O arquivo precisa estar no formato .yml conforme exportado pelo módulo de gerenciamento de campo dinâmico.';

    $Self->{Translation}->{'Here you can export a configuration file of dynamic fields and dynamic field screens to import these on another system. The configuration file is exported in yml format.'} = 'Aqui você pode exportar um arquivo de configuração de campos dinâmicos e telas com campos dinâmicos para importá-los em outro sistema. O arquivo de configuração é exportado no formato yml.';

    $Self->{Translation}->{"Select the desired elements and confirm the import with 'import'."} = "Selecione os elementos desejados e confirme a importação clicando em 'import'.";

    $Self->{Translation}->{'Select the items you want to '} = 'Selecione os itens que você deseja ';

    $Self->{Translation}->{'Here you can manage the dynamic fields in the respective screens.'} = 'Aqui você pode gerenciar os campos dinâmicos nas respectivas telas.';

    $Self->{Translation}->{'The following dynamic fields can not be imported because of an invalid backend.'} = 'Os seguintes campos dinâmicos não podem ser importados devido a um backend inválido.';

    $Self->{Translation}->{'DynamicFields Import'} = 'Importar Campos Dinâmicos';
    $Self->{Translation}->{'DynamicFields Export'} = 'Exportar Campos Dinâmicos';

    $Self->{Translation}->{'Screens'} = 'Telas';
    $Self->{Translation}->{'Fields'}  = 'Campos';

    $Self->{Translation}->{'Export'}  = 'Exportar';
    $Self->{Translation}->{'Import'}  = 'Importar';

    # Screens
    # Frontend
    $Self->{Translation}->{'You can assign elements to this Screen/Field by dragging the elements with the mouse from the left list to the right list.'} = 'Você pode atribuir elementos a esta Tela/Campo arrastando os elementos com o mouse da lista da esquerda para a lista da direita.';

    $Self->{Translation}->{'Manage dynamic field in screens.'} = 'Gerenciar campo dinâmico em telas.';

    $Self->{Translation}->{'Settings were reset.'} = 'As configurações foram redefinidas.';
    $Self->{Translation}->{'Settings were saved.'} = 'As configurações foram salvas.';

    $Self->{Translation}->{'System was not able to save the setting!'}  = 'O sistema não conseguiu salvar a configuração!';
    $Self->{Translation}->{'System was not able to reset the setting!'} = 'O sistema não conseguiu redefinir a configuração!';

    # Elements
    $Self->{Translation}->{'Management of Dynamic Fields <-> Screens'} = 'Gerenciamento de Campos Dinâmicos <-> Telas';

    $Self->{Translation}->{'Dynamic Fields Screens'}  = 'Telas/Campos Dinâmicos';
    $Self->{Translation}->{'DynamicField Screens'}    = 'Telas/Campos Dinâmicos';
    $Self->{Translation}->{'Default Columns Screens'} = 'Telas/Colunas Padrão';
    $Self->{Translation}->{'Dynamic Fields'}          = 'Campos Dinâmicos';

    $Self->{Translation}->{'Available Elements'}         = 'Disponíveis';
    $Self->{Translation}->{'Disabled Elements'}          = 'Desabilitados';
    $Self->{Translation}->{'Assigned Elements'}          = 'Atribuídos';
    $Self->{Translation}->{'Assigned Required Elements'} = 'Atribuídos e Obrigatórios';

    $Self->{Translation}->{'Dynamic Fields for this Screen'}  = 'Campos Dinâmicos nesta Tela';
    $Self->{Translation}->{'Screens for this Dynamic Field'}  = 'Telas com esse Campo Dinâmico';

    # Filter
    $Self->{Translation}->{'Filter Dynamic Fields Screen'}      = 'Filtrar Tela Campos Dinâmicos';
    $Self->{Translation}->{'Filter available elements'}         = 'Filtrar elementos disponíveis';
    $Self->{Translation}->{'Filter disabled elements'}          = 'Filtrar elementos desabilitados';
    $Self->{Translation}->{'Filter assigned elements'}          = 'Filtrar elementos atribuídos';
    $Self->{Translation}->{'Filter assigned required elements'} = 'Filtrar elementos atribuídos e obrigatórios';

    $Self->{Translation}->{'Add DynamicField'}  = 'Adicionar Campo Dinâmico';

    $Self->{Translation}->{'Toggle all available elements'}         = 'Selecionar todos os elementos disponíveis';
    $Self->{Translation}->{'Toggle all disabled elements'}          = 'Selecionar todos os elementos desabilitados';
    $Self->{Translation}->{'Toggle all assigned elements'}          = 'Selecionar todos os elementos atribuídos';
    $Self->{Translation}->{'Toggle all assigned required elements'} = 'Selecionar todos os elementos atribuídos e obrigatórios';

    $Self->{Translation}->{'selected to available elements'}         = 'selecionados para os elementos disponíveis';
    $Self->{Translation}->{'selected to disabled elements'}          = 'selecionados para elementos desabilitados';
    $Self->{Translation}->{'selected to assigned elements'}          = 'selecionados para os elementos atribuídos';
    $Self->{Translation}->{'selected to assigned required elements'} = 'selecionados para os elementos atribuídos e obrigatórios';

    # SysConfig
    $Self->{Translation}->{'This configuration defines if only valids or all (invalids) dynamic fields should be shown.'} = 'Esta configuração define se somente os valores válidos ou todos os campos dinâmicos (inválidos) devem ser mostrados.';

    $Self->{Translation}->{'This configuration defines all possible screens to enable or disable default columns.'} = 'Esta configuração define todas as telas possíveis para habilitar ou desabilitar colunas padrão.';

    $Self->{Translation}->{'This configuration defines all possible screens to enable or disable dynamic fields.'} = 'Esta configuração define todas as telas possíveis para habilitar ou desabilitar campos dinâmicos.';

    return 1;
}

1;
