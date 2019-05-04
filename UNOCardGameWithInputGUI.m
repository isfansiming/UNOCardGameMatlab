function UNOCardGame
    init();
end

function init
    figHandle = figure('Name','UNOCard_Game','MenuBar','none',...    % ����������
    'ToolBar','none','NumberTitle','off',...
    'Units','normalized', 'Position',[0.39 0.30 0.3 0.6],...
    'KeyPressFcn',@keyevent);
    uicontrol(figHandle,'Style','text','Units','normalized',...    % ����UNO��־
    'Position',[0.01,0.81,0.3 0.15],'String','UNO@',...
    'FontSize',25,'FontName','΢���ź�');
    uicontrol(figHandle,'Style','text','Units','normalized',...    % ����UNO��־
    'Position',[0.01,0.50,0.4 0.30],'String','TIPS:ѡ�������������Ƿ���Ϸ���̲��ܿ�ʼ��Ϸ����Ϸ��ֹ����ܿ�ʼ��һ��',...
    'FontSize',15,'FontName','΢���ź�');
    uicontrol(figHandle,'Style','pushbutton','Units','normalized',...
    'Position',[0.33 0.81 0.245 0.09],'String','ѡ������',...
    'FontSize',13,'Callback',@player_choose) % ����ѡ��������ť
    uicontrol(figHandle,'Style','pushbutton','Units','normalized',...
    'Position',[0.60 0.81 0.40 0.09],'String','�Ƿ�ۿ���Ϸ����',...
    'FontSize',13,'Callback',@process_choose) % ����ѡ��������ť
    uicontrol(figHandle,'Style','pushbutton','Units','normalized',...
    'Position',[0.75 0.70 0.245 0.09],'String','��ʼ��Ϸ',...
    'FontSize',13,'Callback',@game_start) % ����ѡ���ѶȰ�ť
end

function player_choose(hobject,handles)
    global numOption numPop numPush
    numOption = dialog('Name','��ѡ����Ϸ����','Units','normalized','Position',[0.45 0.50 0.20 0.20]);  % �Ѷ�ѡ��
    numPop = uicontrol(numOption,'Style','popupmenu','Units','normalized',...  % ����ʽ�˵�
    'Position',[0.31 0.5 0.4 0.4],'String',{'1','2','3','4'},...
    'FontSize',10);
    numPush = uicontrol(numOption,'Style','pushbutton','Units','normalized',...   % ȷ����ť
    'position',[0.3 0.05 0.4 0.32],'String','ȷ��','FontSize',20,'Callback',@pushCallback);
end

function process_choose(hobject,handles)
    global proOption proPop proPush
    proOption = dialog('Name','��ѡ����Ϸ����','Units','normalized','Position',[0.45 0.50 0.20 0.20]);  % �Ѷ�ѡ��
    proPop = uicontrol(proOption,'Style','popupmenu','Units','normalized',...  % ����ʽ�˵�
    'Position',[0.31 0.5 0.4 0.4],'String',{'��','��'},...
    'FontSize',10);
    proPush = uicontrol(proOption,'Style','pushbutton','Units','normalized',...   % ȷ����ť
    'position',[0.3 0.05 0.4 0.32],'String','ȷ��','FontSize',20,'Callback',@retrospect);
end

function pushCallback(hObject,handles)  % ����ѡ�� ȷ����ť �ص�����
    global numPop numOption num_player
    num_player = get(numPop,'Value');
    close(numOption)
end

function retrospect(hObject,handles)
    global proOption proPop pause
    pause = get(proPop,'Value');
    close(proOption)
end

function game_start(hobject,handles)
    global num_player pause
    global  C %���ֵ�洢����Ϸ�Ŀ��Ʋ���
    C = py.dict(pyargs(...
        'clc',1, ...%���ƻ���ˢ��
        'pause',pause, ...%����ÿ�γ��ƺ���ͣ
        'N',108, ...%����
        'P',num_player, ...%����������޸�2~8
        'maxP',8, ...%��������
        'maxPC',50, ...%���������
        'C2C',1, ...%1�����vs���ԣ�0���˻�����ʱ�����޸�
        'color',py.list({'yellow','red','green','blue','black','noColor'}),...
        'function',py.list({'reverse','skip','plus2','plus4','changeColor','none'})...
    ));
    global color2num
    color2num = py.dict(pyargs( ...
        C{'color'}{1},1, ...
        C{'color'}{2},2, ...
        C{'color'}{3},3, ...
        C{'color'}{4},4, ...
        C{'color'}{5},5, ...
        C{'color'}{6},6 ...
    ));
    global function2num
    function2num = py.dict(pyargs( ...
        C{'function'}{1},1, ...
        C{'function'}{2},2, ...
        C{'function'}{3},3, ...
        C{'function'}{4},4, ...
        C{'function'}{5},5, ...
        C{'function'}{6},6 ...
    ));
    global cards
    cards = zeros(C{'N'},3);%3*108�ľ��󣬴��濨�ƿ����Ϣcolor,function,num
    global players_num
    players_num = zeros(1,C{'maxP'});
    global players_cards
    players_cards = zeros(C{'maxP'},C{'maxPC'},3);
    global paidui_num
    paidui_num = 0;
    global used_num
    used_num = 0;
    global used_cards
    used_cards = zeros(C{'N'},3);
    global paidui_cards
    paidui_cards = zeros(C{'N'},3);

    global skipF 
    skipF = 0; %���ڿ��Ƽ�2��4��ֻ�Ժ���һλ�����Ч
    global sdSkip
    sdSkip = 0;%���ڿ���skip��ֻ�Ժ���һλ�����Ч
    global sdReverse
    sdReverse = 0;%���ڿ���reverse��ֻ�Ժ���һλ�����Ч
    global plus
    plus=0;%�ۼƼ�2��4�Ƽӵ�ֵ
    global paihang
    paihang = zeros(1,C{'maxP'});
    global colorNow
    colorNow = 1;
    global numNow
    numNow = 1;
    global using
    using = zeros(1,3);
    %num2clr = py.list({'yellow','red','green','blue','black','noColor'});

%     setGlobal;
%     global C;
%     global players_num;
%     global sdSkip;
%     global sdReverse;
%     global plus;
%     global paihang;
%     global cards;
    %players_num = zeros(1,C{'maxP'});
    disp('Game Start!')
	i=1;%������
    j=0;
    k=1;%reverse��*=-1
    q=0;%��ʤ�����
    lost=0;%ʣ�µ���ҵ����
    plus=0;
    
    i=randi(C{'P'});%�������˭�ȳ���
    initialize;
    fprintf('�����:%d.\n���%d�ȳ���.\n',C{'P'},i)
    sheffle_init;
%     for ii=1:108
%         printCard(cards(ii,:));
%         if mod(ii,8)==0
%             fprintf('\n');
%         end
%     end

    fapai();
%�ƶ�������
%     for ii=1:10
%         printCard(paidui_cards(ii,:));
%         if mod(ii,8)==0
%             fprintf('\n');
%         end
%     end     
    winning = 0;
    while 1
        while 1%��ѭ�������ڳ���ʱ�����Ѿ���ʤ�����
            if players_num(i)>0
                break;
            end
            i = next(i,k);
            j = j + 1;
            if j >= C{'P'}
                j = 0;
                winning = 1;
                break;
            end
        end
        if winning == 0
            j = 0;
            output(i);%��ʾ��Ϣ
        end
        q = winnerProcess(q);
        if alldone(q) == 1,
            break;
        end
        
        if sdReverse == 1
            sdReverse = 0;
            if C{'P'}-q ~= 2
                fprintf('\nReverse\n');
                k = -k;
            else
                sdSkip = 1;%��ֻʣ2��ʱ����reverse��skip��
            end
        end
        
        if sdSkip == 1
            sdSkip = 0;
            i = next(i,k);
            while players_num(i)<=0
                i = next(i,k);
            end
            fprintf('\nSkip player %d\n',i);
        end
        
        i = next(i,k);
        collect;
        disp('����������Լ���');
        if(C{'pause'}==1)
            system('pause');
        end
        if(C{'clc'}==1)
            clc;
        end
    end
    fprintf('\n');
    clc;
    for ii=1:C{'P'}
        if ii~=C{'P'}
            fprintf('��%d����ʤ������:Player %d.\n',ii,paihang(ii));
        end
        lost = lost + ii;
    end
    for ii=1:C{'P'}-1
        lost = lost - paihang(ii);
    end
    fprintf('�������������:Player %d.\n',lost);
    disp('������������˳�');
%      fprintf('%d',num_player);
    system('pause');
end


function r = next(i,k)
    global C;
    i = i + k;
    if i>C{'P'}
        i=1;
    elseif i<1
        i = C{'P'};
    end
    r = i;
end
function r=winnerProcess(q)
    global players_num;
    global C;
    global paihang;
    for i=1:C{'P'}
        if players_num(i)==0
            paihang(q+1)=i;
            q = q + 1;
            players_num(i) = -1;
        end
    end
    r = q;
end
function r=alldone(q)
    global C;
    if(q==C{'P'}-1)
        r=1;
    else
        r=0;
    end
end
function collect()
    global used_num;
    global used_cards;
    global paidui_num;
    global paidui_cards;
    if used_num>=60
        %system('pause')
        for i = 1:60
            paidui_num = paidui_num + 1;
            paidui_cards(paidui_num,:) = used_cards(used_num,:);
            used_num = used_num - 1;
        end
    end
    sheffle;
end
function initialize()
    global color2num;
    global function2num;
    global cards;
    global paidui_num;
    global used_num;
    for i = 1:19
        cards(i,1) = color2num{'yellow'};
        cards(i,2) = function2num{'none'};
        if i == 1
            cards(i,3) = 0;
        else
            cards(i,3) = mod(i-1,10)+floor((i-1)/10);%ֻ��һ��0��������1~9
        end
    end
    for i = 20:38
        cards(i,1) = color2num{'red'};
        cards(i,2) = function2num{'none'};
        if i == 20
            cards(i,3) = 0;
        else
            cards(i,3) = mod(i-20,10)+floor((i-20)/10);
        end
    end
    for i = 39:57
        cards(i,1) = color2num{'green'};
        cards(i,2) = function2num{'none'};
        if i == 39
            cards(i,3) = 0;
        else
            cards(i,3) = mod(i-39,10)+floor((i-39)/10);
        end
    end
    for i = 58:76
        cards(i,1) = color2num{'blue'};
        cards(i,2) = function2num{'none'};
        if i == 58
            cards(i,3) = 0;
        else
            cards(i,3) = mod(i-58,10)+floor((i-58)/10);
        end
    end
    for i = 77:84
        cards(i,1) = mod(i-1,4)+1;
        cards(i,2) = function2num{'reverse'};
        cards(i,3) = -1;
    end
    for i = 85:92
        cards(i,1) = mod(i-1,4)+1;
        cards(i,2) = function2num{'skip'};
        cards(i,3) = -1;
    end
    for i = 93:100
        cards(i,1) = mod(i-1,4)+1;
        cards(i,2) = function2num{'plus2'};
        cards(i,3) = -1;
    end
    for i = 101:104
        cards(i,1) = color2num{'black'};
        cards(i,2) = function2num{'changeColor'};
        cards(i,3) = -2;
    end
    for i = 105:108
        cards(i,1) = color2num{'black'};
        cards(i,2) = function2num{'plus4'};
        cards(i,3) = -2;
    end
    
    paidui_num = 0;
    used_num = 0;
end

function sheffle %ϴ��
    global paidui_cards;
    global paidui_num;
    global C;
    n=paidui_num;
    for i = 1:5*C{'N'}
        ran1 = randi(n);
        ran2 = randi(n);
        %switch
        temp = paidui_cards(ran1,:);
        paidui_cards(ran1,:) = paidui_cards(ran2,:);
        paidui_cards(ran2,:) = temp;
    end
end
function sheffle_init
    global C;
    global cards;
    for i = 1:5*C{'N'}
        ran1 = randi(C{'N'});
        ran2 = randi(C{'N'});
        %switch
        temp = cards(ran1,:);
        cards(ran1,:) = cards(ran2,:);
        cards(ran2,:) = temp;
    end
end
function fapai
    global C;
    global players_cards;
    global players_num;%players_card = zeros(C{'maxP'},C{'maxPC'},3);
    global cards;
    global paidui_cards;
    global paidui_num;
    for i=1:C{'P'}
        for j=1:5
            players_cards(i,j,:) = cards(5*(i-1)+j,:);
        end
        players_num(i) = players_num(i) + 5;
    end
    paidui_num = C{'N'}-5*C{'P'};
    for i=1:paidui_num
        paidui_cards(i,:) = cards(i+5*C{'P'},:);
    end
end
function printCards(who)
    global players_num;
    global players_cards;
    fprintf("Player %d ����: ",who)
    for i=1:players_num(who),
        printCard(players_cards(who,i,:));
    end
    fprintf('\n')
end
function output(who)
    global C;
    global players_num;
    global used_num;
    global color2num;
    global colorNow;
    global numNow;
    global using;
    global paidui_num;
    fprintf('��������%d����,',used_num);
    fprintf('�ƶ�ʣ��%d����\n',paidui_num);
    printCards(1);
    printCards(2);
    printCards(3);
    printCards(4);
    for i=1:C{'P'},
        if players_num(i)>0,
            fprintf('Player%d��%2d����\n',i,players_num(i))
        else
            fprintf('Player%d�Ѿ�Ӯ��\n',i)
        end
    end
    if used_num ~=0,
        fprintf('��ǰ��:')
        printCard(using)
        if using(1)==color2num{'black'},
            fprintf('�޸���ɫΪ:')
            fprintf('%s',C{'color'}{colorNow})
            fprintf('\n�޸�����Ϊ:%d\n',numNow)
        end
    end
    if C{'C2C'} == 1
        fprintf('\nplayer %d''s turn:\n',who);
    end
    comInput(who)
end
function printCard(x)
    global C;
    fprintf('%s',C{'color'}{x(1)});
    if x(3)>=0
        fprintf('%d ',x(3));
    else
        fprintf('%s',C{'function'}{x(2)})
        fprintf(' ');
    end
end
function useCard(who,which)
    global players_cards;
    global players_num;
    global used_num;
    global used_cards;
    global colorNow;
    global numNow;
    global plus;
    global sdSkip;
    global sdReverse;
    global function2num;
    global color2num;
    global using;
    using = players_cards(who,which,:);
    used_cards(used_num+1,:) =  players_cards(who,which,:);
    players_cards(who,which,:) = players_cards(who,players_num(who),:);
    players_num(who) = players_num(who) - 1;
    used_num = used_num +1;
    fprintf('Player %d ���  :',who);
    printCard(using);
    if using(1)~=color2num{'black'},%���Ǻ�ɫ�ƣ�����µ�ǰ��ɫ
       colorNow = using(1);
    else,%����Ǻ�ɫ�ƣ���ѡ����ɫ
        colorNow = randi(4);
        while hasColor(who,colorNow)==0,
            colorNow = randi(4);
        end
    end
    if using(2)==function2num{'plus4'}
        plus = plus + 4;
    elseif using(2)==function2num{'plus2'}
        plus = plus + 2;
    end
    if using(3)>=0%���������������
        numNow = using(3);
    end
    if using(2)==function2num{'skip'}
        sdSkip = 1;
    end
    if using(2)==function2num{'reverse'}
        sdReverse = 1;
    end
end

function r = check(who,which)
    global players_cards;
    global function2num;
    global color2num;
    global used_num;
    global skipF;
    global using;
    global colorNow;
    global numNow;
    global players_num;
    if players_num(who)==1 && players_cards(who,which,2)~=function2num{'none'}
        r = 0;%���һ���Ʋ��ܳ�������
        return;
    end
    if used_num==0%��һ���ƿ�������
        r = 1;
        return;
    end
    if skipF==1%�����һλ������ڼ�2��4�Ʊ�������������λ��ҿ����������ڵļ�2��4�ƵĹ��ܣ�ֻ��Ҫ���ʵ�����ɫ\����
        if (players_cards(who,which,1)==colorNow) || (players_cards(who,which,1)==color2num{'black'}) || ... 
                (players_cards(who,which,3)==numNow)
            r = 1;%��ɫ������һ�����Գ�
            return;
        else
            r = 0;
            return;
        end
    else
        if players_cards(who,which,2)==function2num{'plus4'}%��+4��ʲô���ܳ�
            r = 1;
            return;
        elseif using(2)==function2num{'plus4'}%û+4���ܳ���+4����
            r = 0;
            return;
        end
        if players_cards(who,which,2)==function2num{'plus2'}%��+2��ʲô���ܳ�(��+4)
            r = 1;
            return;
        elseif using(2)==function2num{'plus2'}%û+2���ܳ���+2����(��+4)
            r = 0;
            return;
        end
        if players_cards(who,which,1)==color2num{'black'}%�к���ʲô���ܳ�(��+2+4)
            r = 1;
            return;
        elseif using(1)==color2num{'black'},
            if (players_cards(who,which,1)==colorNow)||(players_cards(who,which,3)==numNow) 
                r = 1;%��ɫ������һ�����Գ�
                return;
            else
                r = 0;
                return;
            end
        end
           
        if using(3)==-1,%�����ǰ�ǹ�����
            if (players_cards(who,which,1)==colorNow) || (players_cards(who,which,2)==using(2))
                r = 1;
                return;
            else
                r = 0;
                return;
            end
        end 
        
        if (players_cards(who,which,1)==colorNow)||(players_cards(who,which,1)==color2num{'black'})|| ... 
                (players_cards(who,which,3)==numNow) 
            r = 1;%��ɫ������һ�����Գ�
            return;
        else
            r = 0;
            return;
        end
    end
end
function comInput(who)
    global using;
    global plus;
    global skipF;
    global function2num;
    global players_num;
    for i=1:players_num(who),%��������
        if check(who,i)==1%������ã��ͳ���
            useCard(who,i)
            skipF = 0;
            return;
        end
    end
    %���û�п��Գ����ƣ������
    if using(2)==function2num{'plus4'},
        takeCard(who,max(1,plus));
        skipF = 1;
        plus = 0;
    elseif using(2)==function2num{'plus2'},
        takeCard(who,max(1,plus));
        skipF = 1;
        plus = 0;
    else
        takeCard(who,1);%û�Ƴ�������
    end
end
function r = hasColor(who,c)
    global players_num;
    global players_cards;
    for i=1:players_num(who),
        if c==players_cards(who,i,1)
            r=1;
            return;
        end
    end
    r = 0;
end
function takeCard(who,x)
    global players_cards;
    global paidui_num;
    global players_num;
    global paidui_cards;

    %fprintf('who:%d,players_num(who)+1==%d\n',who,players_num(who)+1)f
    %fprintf('paidui_num:%d\n,used_num:%d\n',paidui_num,used_num);
    for i=1:x,
        players_cards(who,players_num(who)+1,:) = paidui_cards(paidui_num,:);
        paidui_num = paidui_num - 1;
        players_num(who) = players_num(who) + 1;
    end
    fprintf('\nPlayer %d ���� %d ����,�ֱ���\n',who,x);
    for i=x-1:-1:0,
        printCard(paidui_cards(paidui_num-i,:))
    end
    fprintf('\n')
end