function suffix = mouseSuffix(mouse)
    switch mouse
        case '1850'
            suffix = {'1850ACSF','1850AMPH','1850CARB'};
        case '269'
            suffix = {'269AMPH110815'};
        case '263'
            suffix = {'263ACSF110815',...
                '263ETIC100515'};
        case '4003'
            suffix = {'4003AMPH','4003CARB','4003MECA2','4003SCOP2'};
        case '4539'
            suffix = {'4539ACSF','4539BL'};
        case '689'
            suffix = {'689ACSF092515'};
        case '6028'
            suffix = {'6028AMPH021516'};
        case '7212'
            suffix = {'7212ACSF050416','7212AMPH051316'};
        case '7584'
            suffix = {'7584AMPH','7584MECA'};
        case '7136'
            suffix = {'7136ACSF050616','7136AMPH042216',...
                '7136SCH051916'};
        case '2565'
            suffix = {'2565ACSF','2565SCOP','2565AMPH','2565CARB'};
        case '7909'
            suffix = {'7909AMPH2','7909BL','7909BL2'};
        case 'fsi'
            load('mouseList.mat');
            suffix = mouseList(23:end);
        case 'chi'
            load('mouseList.mat');
            suffix = mouseList(1:22);
            suffix([2 4 5 6 12 13]) = [];
        case 'all'
            load('mouseList.mat');
            suffix = mouseList;
            suffix([2 4 5 6 12 13]) = [];
        case 'good'
            suffix = {'2565ACSF', '2565SCOP', '263ACSF110815', '4003SCOP2', '689ACSF092515',...
                '7136ACSF050616', '7136AMPH042216', '7136SCH051916', '7584MECA', '269AMPH110815', '1850ACSF',...
                '1850AMPH','1850CARB','2565AMPH','2565CARB','263ETIC100515','4003AMPH', '4003CARB',...
                '4003MECA2', '6028AMPH021516','7212ACSF050416','7212AMPH051316','7584AMPH','7909BL','7909BL2','4539BL','4539ACSF','7909AMPH2'}; 
        case 'goodnew'
            suffix = {'2565ACSF072017', '2565SCOP081816', '263ACSF110815', '4003SCOP2091616', '689ACSF092515',...
                '7136ACSF050616', '7136AMPH042216', '7136SCH051916', '7584MECA091316', '269AMPH110815', '1850ACSF071816',...
                '1850AMPH072216','1850CARB080516','2565AMPH071416','2565CARB081216','263ETIC100515','4003AMPH090716', '4003CARB082816',...
                '4003MECA2091916', '6028AMPH021516','7212ACSF050416','7212AMPH051316','7584AMPH090716','7909BL','7909BL2','4539BL','4539ACSF110316','7909AMPH2111016'}; 
        case 'great'
            suffix = {'2565ACSF', '2565SCOP', '263ACSF110815', '4003SCOP2', '689ACSF092515',...
                '7136ACSF050616', '7136AMPH042216', '7136SCH051916', '7584MECA', '269AMPH110815', '1850ACSF'};
            
        otherwise
            suffix = {mouse};
    end
    
end