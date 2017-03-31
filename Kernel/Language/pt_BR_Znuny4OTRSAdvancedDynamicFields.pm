# --
# Copyright (C) 2017 Edicarlos Lopes dos Santos <edicarlos.lds@gmail.com>
# Copyright (C) 2012-2017 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_Znuny4OTRSAdvancedDynamicFields;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Importar / Exportar
    $Self->{Translation}->{'Here you can upload a configuration file to import dynamic fields to your system. The file needs to be in .yml format as exported by dynamic field management module.'} = 'Aqui você pode carregar um arquivo de configuração para importar campos dinâmicos para o seu sistema. O arquivo precisa estar no formato .yml exportado pelo módulo de gerenciamento de campo dinâmico.';

    $Self->{Translation}->{'Here you can manage the dynamic fields in the respective screens.'} = 'Aqui você pode gerenciar os campos dinâmicos nas respectivas telas.';

    $Self->{Translation}->{'DynamicFields Import'} = 'Importar Campos Dinâmicos';
    $Self->{Translation}->{'DynamicFields Export'} = 'Exportar Campos Dinâmicos';

    # Telas
    $Self->{Translation}->{'You can assign elements to this Screen/Field by dragging the elements with the mouse from the left list to the right list.'} = 'Você pode atribuir elementos a esta Tela/Campo arrastando os elementos com o mouse da lista da esquerda para a lista da direita.';
    $Self->{Translation}->{"Ordering the elements within the list is also possible by drag 'n' drop."} = "Também é possível ordenar os elementos na lista através de arrastar e soltar.";
    $Self->{Translation}->{'Manage dynamic field in screens.'} = 'Gerenciar campo dinâmico em telas.';

    # Elementos
    $Self->{Translation}->{'Management of Dynamic Fields <-> Screens'} = 'Gerenciamento de Campos Dinâmicos <-> Telas';

    $Self->{Translation}->{'Dynamic Fields Screens'}  = 'Telas Campos Dinâmicos';
    $Self->{Translation}->{'DynamicField Screens'}    = 'Telas Campos Dinâmicos';
    $Self->{Translation}->{'Default Columns Screens'} = 'Telas Colunas Padrão';
    $Self->{Translation}->{'Dynamic Fields'}          = 'Campos Dinâmicos';

    $Self->{Translation}->{'Available Elements'}         = 'Disponíveis';
    $Self->{Translation}->{'Disabled Elements'}          = 'desabilitados';
    $Self->{Translation}->{'Assigned Elements'}          = 'Atribuídos';
    $Self->{Translation}->{'Assigned Required Elements'} = 'Atribuídos e Obrigatórios';

    $Self->{Translation}->{'Dynamic Fields for this Screen'} = 'Campos Dinâmicos para esta Tela';
    $Self->{Translation}->{'Screens for this Dynamic Field'} = 'Telas para este Campo Dinâmico';

    # Filtros
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
    $Self->{Translation}->{'This configuration defines if only valids or all (invalids) dynamic fields should be shown.'} ='Esta configuração define se somente os valores válidos ou todos os campos dinâmicos (inválidos) devem ser mostrados.';
    $Self->{Translation}->{'This configuration defines all possible screens to enable or disable default columns.'} ='Esta configuração define todas as telas possíveis para habilitar ou desabilitar colunas padrão.';
    $Self->{Translation}->{'This configuration defines all possible screens to enable or disable dynamic fields.'} ='Esta configuração define todas as telas possíveis para habilitar ou desabilitar campos dinâmicos.';

    return 1;
}

1;
