%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Import MSB data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


boxNumber = inputdlg('Motion sensor box serial number (MSB00XX)',...
    'MSB-Nr.');
saveName = genvarname(boxNumber{1});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Import IMU

files = dir('imu*.csv'); 
a = length(files); % Number of imu*.csv files

for i = 1:a
    
    fileName = files(i).name;

    [epoch, acc_x, acc_y, acc_z, rot_x, rot_y, rot_z, mag_x, mag_y,... 
        mag_z, temp] = importMSBDataIMU(fileName); % Import data
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                   Rotation
    exist rot;                  % Check if the matrix for the data 
    % already exist, else create the matrix
    
    if ans == 0
        rot = [];
    end
    
    TF = isempty(rot);           % Checkif data matrix is empty, 
    % if empty store rot data in matrix, else store at the end of the 
    % matrix
    
    if TF == 1;
        rot(:,1) = rot_x;
        rot(:,2) = rot_y;
        rot(:,3) = rot_z;
    else TF == 0;
        A = [rot(:,1); rot_x];
        B = [rot(:,2); rot_y];
        C = [rot(:,3); rot_z];
        rot = [A, B, C];
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                   Acceleration
    exist acc;                  % Check if the matrix for the data 
    % already exist, else create the matrix
    
    if ans == 0
        acc = [];
    end
    
    TF = isempty(acc);           % Checkif data matrix is empty, 
    % if empty store acc data in matrix, else store at the end of the 
    % matrix
    
    if TF == 1;
        acc(:,1) = acc_x;
        acc(:,2) = acc_y;
        acc(:,3) = acc_z;
    else TF == 0;
        A = [acc(:,1); acc_x];
        B = [acc(:,2); acc_y];
        C = [acc(:,3); acc_z];
        acc = [A, B, C];
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                   Magnitude
    exist mag;                  % Check if the matrix for the data 
    % already exist, else create the matrix
    
    if ans == 0
        mag = [];
    end
    
    TF = isempty(mag);           % Check if data matrix is empty, 
    % if empty store mag data in matrix, else store at the end of the 
    % matrix
    
    if TF == 1;
        mag(:,1) = mag_x;
        mag(:,2) = mag_y;
        mag(:,3) = mag_z;
    else TF == 0;
        A = [mag(:,1); mag_x];
        B = [mag(:,2); mag_y];
        C = [mag(:,3); mag_z];
        mag = [A, B, C];
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                   Epoch IMU
    exist epochIMU;                  % Check if the matrix for the 
    % data already exist, else create the matrix
  
    if ans == 0
        epochIMU = [];
    end

    epochIMU = [epochIMU; epoch];

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Import ATT

files = dir('att*.csv'); 
a = length(files); % Number of att*.csv files

for i = 1:a
    
    fileName = files(i).name;

    [epoch, roll, roll_comp, yaw, yaw_comp] = ...
        importMSBDataATT(fileName); % Import data
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                   Roll
    exist rollData;                  % Check if the matrix for the data 
    % already exist, else create the matrix
  
    if ans == 0
        rollData = [];
    end

    rollData = [rollData; roll];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                   Roll_Comp
    exist roll_compData;                  % Check if the matrix for the 
    % data already exist, else create the matrix
  
    if ans == 0
        roll_compData = [];
    end

    roll_compData = [roll_compData; roll_comp];


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                   Yaw
    exist yawData;                  % Check if the matrix for the data 
    % already exist, else create the matrix
  
    if ans == 0
        yawData = [];
    end

    yawData = [yawData; yaw];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                   Yaw_Comp
    exist yaw_compData;                  % Check if the matrix for the 
    % data already exist, else create the matrix
  
    if ans == 0
        yaw_compData = [];
    end

    yaw_compData = [yaw_compData; yaw_comp];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                   Epoch ATT
    exist epochATT;                  % Check if the matrix for the 
    % data already exist, else create the matrix
  
    if ans == 0
        epochATT = [];
    end

    epochATT = [epochATT; epoch];

end

roll = rollData;
roll_comp = roll_compData;
yaw = yawData;
yaw_comp = yaw_compData;

save(saveName, "rot", "acc", "mag", "epochIMU", "roll", "roll_comp", ...
    "yaw", "yaw_comp", "epochATT"); %roll =roll_comp, roll_comp= yaw_comp, yaw= roll, yaw_comp =roll



