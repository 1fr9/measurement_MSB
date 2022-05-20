%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Analyze MSB Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


boxNumber = inputdlg('Motion sensor box serial number (MSB00XX)',...
    'MSB-Nr.');
fileName = genvarname(boxNumber{1});
fileName = fileName + ".mat";

uiopen(fileName);

question = 2;

while question == 2
    fig1 = figure('Name','Interval selecting',...
        'Position',[100 150 1250 500]);
%     plot(rot(:,3));
    plot(roll_comp);
    title('Set the interfvalle by selecting the extreme values')
    for i = 1:6
        hold on
        [x, y] = ginput(1);
        a = round(x);
        b = round(y);
        int(i,:) = [a, b];     
        plot(x,y, 'o', 'MarkerFaceColor', 'r','MarkerEdgeColor', 'r')
    end

    close

    intBrdrs = int(:,1);
    
    fig2 = figure('Name','Intervals','Position',[100 150 1250 500]);
%     plot(rot(:,2));
    plot(roll_comp);
    hold on 
    xline(intBrdrs);
    
    question = menu('Are the selected intervals correct?', 'Yes','No');
end

close;

intSize = zeros(5, 1);

for i = 1:5
    low = intBrdrs(i);
    up = intBrdrs(i+1);
    a = up-low;
    intSize(i,1) = a;    
end

angleData = zeros(max(intSize), 5);

for i = 1:5
    a = intSize(i);
    b = intBrdrs(i);
    c = intBrdrs(i+1);
    for j = b:c
        d = j - b +1;
        angleData(d,i) = roll_comp(j);
    end
end

angleData(angleData == 0) = NaN;

diffAngle= zeros(max(intSize),5);

for i = 1:5
    diffAngle(:,i) = diff(angleData(:,i));
    h = diffAngle(:,i);
    h = h(~isnan(h));
    ipt(:,i) = findchangepts(h,"MaxNumChanges", 20);
end

a = [2 3 6 7 10 11 14 15 18 19];
b = [4 5 8 9 12 13 16 17];

aOddIdx = a(1:2:end);
aEvenIdx = a(2:2:end);

bOddIdx = b(1:2:end);
bEvenIdx = b(2:2:end);

meanDeg = zeros(5, 2, 5);

figName = char(boxNumber);
figCalcAngle = figure ('Position', [100 50 1400 700]);
sgtitle(figName);
hold on

for i = 1:5

    for j = 1:5
        defIntA(j,1) = ipt(aOddIdx(j),i);
        defIntA(j,2) = ipt(aEvenIdx(j),i);
        meanDeg(j,1,i) = mean(angleData(defIntA(j,1):defIntA(j,2), i));
    end

    for k = 1:4
        defIntB(k,1) = ipt(bOddIdx(k),i);
        defIntB(k,2) = ipt(bEvenIdx(k),i);
        meanDeg(k,2,i) = mean(angleData(defIntB(k,1):defIntB(k,2),i));
    end

    deg = i+1;
    angle = angleData(:,i);
    subplot(5,1,i)
    hold on
    plot(angle, 'Color', 'b');
    title("Angle: " + deg +"°")
    xline(ipt(:,i));

    for o = 1:5
        line([defIntA(o,1), defIntA(o,2)],[meanDeg(o,1,i),...
            meanDeg(o,1,i)], 'Color', 'r');
        txt = meanDeg(o,1,i);
        txt = num2str(txt);
        txtPosX = defIntA(o,1) + 10;
        txtPosY = meanDeg(o,1,i) - 0.5;
        text(txtPosX, txtPosY, txt);
    end
    
    for p = 1:4
        line([defIntB(p,1), defIntB(p,2)],[meanDeg(p,2,i),...
            meanDeg(p,2,i)], 'Color', 'g');
        txt = meanDeg(p,2,i);
        txt = num2str(txt);
        txtPosX = (defIntB(p,1) + 10);
        txtPosY = meanDeg(p,2,i) + 0.5;
        text(txtPosX, txtPosY, txt);
    end
end

saveas(gcf, figName, 'png');

for i = 1:5
    for j = 1:4
        relAngle21(j,i) = meanDeg(j,1,i) - meanDeg(j,2,i);
        relAngle12(j,i) = meanDeg(j,2,i) - meanDeg(j+1,1,i);
    end
end

relAngle12 = -relAngle12;

saveName = 'Processed' + fileName 

save(saveName, "rot", "acc", "mag", "epochIMU", "roll", "roll_comp", ...
    "yaw", "yaw_comp", "epochATT","relAngle12","relAngle21","meanDeg");

