#!/bin/bash
source test_tipc/common_func.sh

FILENAME=$1

# set -xe

:<<!
MODE be one of ['lite_train_lite_infer' 'lite_train_whole_infer' 'whole_train_whole_infer',
#                 'whole_infer',
#                 'cpp_infer', ]
!

MODE=$2

dataline=$(cat ${FILENAME})

python3.7 -m pip install unrar

git clone https://github.com/LDOUBLEV/AutoLog
cd AutoLog
python3.7 -m pip install -r requirements.txt
python3.7 setup.py bdist_wheel
python3.7 -m pip install ./dist/auto_log-1.0.0-py3-none-any.whl
cd ..

# parser params
IFS=$'\n'
lines=(${dataline})

# The training params
model_name=$(func_parser_value "${lines[1]}")

trainer_list=$(func_parser_value "${lines[14]}")




if [ ${MODE} = "lite_train_lite_infer" ];then
    if [ ${model_name} == "PP-TSM" ]; then
        # pretrain lite train data
        pushd ./data/k400
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/train_link.list
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/val_link.list
        bash download_k400_train.sh
        bash download_k400_val.sh
        popd
        # download pretrained weights
        wget -nc -P ./data https://videotag.bj.bcebos.com/PaddleVideo/PretrainModel/ResNet50_vd_ssld_v2_pretrained.pdparams --no-check-certificate
    elif [ ${model_name} == "PP-TSN" ]; then
        # pretrain lite train data
        pushd ./data/k400
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/train_link.list
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/val_link.list
        bash download_k400_train.sh
        bash download_k400_val.sh
        popd
        # download pretrained weights
        wget -nc -P ./data https://videotag.bj.bcebos.com/PaddleVideo/PretrainModel/ResNet50_vd_ssld_v2_pretrained.pdparams --no-check-certificate
    elif [ ${model_name} == "AGCN" ]; then
        # pretrain lite train data
        pushd data/fsd10
        wget -nc https://videotag.bj.bcebos.com/Data/FSD_train_data.npy
        wget -nc https://videotag.bj.bcebos.com/Data/FSD_train_label.npy
        popd
    elif [ ${model_name} == "STGCN" ]; then
        # pretrain lite train data
        pushd data/fsd10
        wget -nc https://videotag.bj.bcebos.com/Data/FSD_train_data.npy
        wget -nc https://videotag.bj.bcebos.com/Data/FSD_train_label.npy
        popd
    elif [ ${model_name} == "TSM" ]; then
        # pretrain lite train data
        pushd ./data/k400
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/train_link.list
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/val_link.list
        bash download_k400_train.sh
        bash download_k400_val.sh
        popd
        # download pretrained weights
        wget -nc -P ./data https://videotag.bj.bcebos.com/PaddleVideo/PretrainModel/ResNet50_vd_ssld_v2_pretrained.pdparams --no-check-certificate
    elif [ ${model_name} == "TSN" ]; then
        # pretrain lite train data
        pushd ./data/k400
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/train_link.list
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/val_link.list
        bash download_k400_train.sh
        bash download_k400_val.sh
        python3.7 extract_rawframes.py ./videos/ ./rawframes/ --level 2 --ext mp4 # extract frames from video file

        # download annotations
        wget https://videotag.bj.bcebos.com/PaddleVideo/Data/Kinetic400/train_frames.list
        wget https://videotag.bj.bcebos.com/PaddleVideo/Data/Kinetic400/val_frames.list
        popd
        # download pretrained weights
        wget -nc -P ./data https://videotag.bj.bcebos.com/PaddleVideo/PretrainModel/ResNet50_vd_ssld_v2_pretrained.pdparams --no-check-certificate
    elif [ ${model_name} == "TimeSformer" ]; then
        # pretrain lite train data
        pushd ./data/k400
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/train_link.list
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/val_link.list
        bash download_k400_train.sh
        bash download_k400_val.sh
        popd
        # download pretrained weights
        wget -nc -P ./data https://paddle-imagenet-models-name.bj.bcebos.com/dygraph/ViT_base_patch16_224_pretrained.pdparams --no-check-certificate
    elif [ ${model_name} == "AttentionLSTM" ]; then
        # pretrain lite train data
        pushd data/yt8m
        mkdir frame
        cd frame
        ## download & decompression training data
        curl data.yt8m.org/download.py | partition=2/frame/train mirror=asia python
        curl data.yt8m.org/download.py | partition=2/frame/validate mirror=asia python
        python3.7 -m pip install tensorflow-gpu==1.14.0
        cd ..
        python3.7 tf2pkl.py ./frame ./pkl_frame/
        ls pkl_frame/train*.pkl > train.list # 将train*.pkl的路径写入train.list
        ls pkl_frame/validate*.pkl > val.list # 将validate*.pkl的路径写入val.list

        python3.7 split_yt8m.py train.list # 拆分每个train*.pkl变成多个train*_split*.pkl
        python3.7 split_yt8m.py val.list # 拆分每个validate*.pkl变成多个validate*_split*.pkl

        ls pkl_frame/train*_split*.pkl > train.list # 将train*_split*.pkl的路径重新写入train.list
        ls pkl_frame/validate*_split*.pkl > val.list # 将validate*_split*.pkl的路径重新写入val.list
        popd
    elif [ ${model_name} == "SlowFast" ]; then
        # pretrain lite train data
        pushd ./data/k400
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/train_link.list
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/val_link.list
        bash download_k400_train.sh
        bash download_k400_val.sh
        popd
    elif [ ${model_name} == "BMN" ]; then
        # pretrain lite train data
        pushd ./data
        mkdir bmn_data
        cd bmn_data
        wget -nc https://paddlemodels.bj.bcebos.com/video_detection/bmn_feat.tar.gz
        tar -zcvf bmn_feat.tar.gz
        wget -nc https://paddlemodels.bj.bcebos.com/video_detection/activitynet_1.3_annotations.json
        wget -nc https://paddlemodels.bj.bcebos.com/video_detection/activity_net_1_3_new.json
        popd

    else
        echo "Not added into TIPC yet."
    fi

elif [ ${MODE} = "whole_train_whole_infer" ];then
    if [ ${model_name} == "PP-TSM" ]; then
        # pretrain whole train data
        pushd ./data/k400
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/train_link.list
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/val_link.list
        bash download_k400_train.sh
        bash download_k400_val.sh
        popd
        # download pretrained weights
        wget -nc -P ./data https://videotag.bj.bcebos.com/PaddleVideo/PretrainModel/ResNet50_vd_ssld_v2_pretrained.pdparams --no-check-certificate
    elif [ ${model_name} == "PP-TSN" ]; then
        # pretrain whole train data
        pushd ./data/k400
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/train_link.list
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/val_link.list
        bash download_k400_train.sh
        bash download_k400_val.sh
        popd
        # download pretrained weights
        wget -nc -P ./data https://videotag.bj.bcebos.com/PaddleVideo/PretrainModel/ResNet50_vd_ssld_v2_pretrained.pdparams --no-check-certificate
    elif [ ${model_name} == "AGCN" ]; then
        # pretrain lite train data
        pushd data/fsd10
        wget -nc https://videotag.bj.bcebos.com/Data/FSD_train_data.npy
        wget -nc https://videotag.bj.bcebos.com/Data/FSD_train_label.npy
        popd
    elif [ ${model_name} == "STGCN" ]; then
        # pretrain lite train data
        pushd data/fsd10
        wget -nc https://videotag.bj.bcebos.com/Data/FSD_train_data.npy
        wget -nc https://videotag.bj.bcebos.com/Data/FSD_train_label.npy
        popd
    elif [ ${model_name} == "TSM" ]; then
        # pretrain lite train data
        pushd ./data/k400
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/train_link.list
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/val_link.list
        bash download_k400_train.sh
        bash download_k400_val.sh
        popd
        # download pretrained weights
        wget -nc -P ./data https://videotag.bj.bcebos.com/PaddleVideo/PretrainModel/ResNet50_vd_ssld_v2_pretrained.pdparams --no-check-certificate
    elif [ ${model_name} == "TSN" ]; then
        # pretrain lite train data
        pushd ./data/k400
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/train_link.list
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/val_link.list
        bash download_k400_train.sh
        bash download_k400_val.sh
        python3.7 extract_rawframes.py ./videos/ ./rawframes/ --level 2 --ext mp4 # extract frames from video file

        # download annotations
        wget https://videotag.bj.bcebos.com/PaddleVideo/Data/Kinetic400/train_frames.list
        wget https://videotag.bj.bcebos.com/PaddleVideo/Data/Kinetic400/val_frames.list
        popd
        # download pretrained weights
        wget -nc -P ./data https://videotag.bj.bcebos.com/PaddleVideo/PretrainModel/ResNet50_vd_ssld_v2_pretrained.pdparams --no-check-certificate
    elif [ ${model_name} == "TimeSformer" ]; then
        # pretrain lite train data
        pushd ./data/k400
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/train_link.list
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/val_link.list
        bash download_k400_train.sh
        bash download_k400_val.sh
        popd
        # download pretrained weights
        wget -nc -P ./data https://paddle-imagenet-models-name.bj.bcebos.com/dygraph/ViT_base_patch16_224_pretrained.pdparams --no-check-certificate
    elif [ ${model_name} == "AttentionLSTM" ]; then
        # pretrain lite train data
        pushd data/yt8m
        mkdir frame
        cd frame
        ## download & decompression training data
        curl data.yt8m.org/download.py | partition=2/frame/train mirror=asia python
        curl data.yt8m.org/download.py | partition=2/frame/validate mirror=asia python
        python3.7 -m pip install tensorflow-gpu==1.14.0
        cd ..
        python3.7 tf2pkl.py ./frame ./pkl_frame/
        ls pkl_frame/train*.pkl > train.list # 将train*.pkl的路径写入train.list
        ls pkl_frame/validate*.pkl > val.list # 将validate*.pkl的路径写入val.list

        python3.7 split_yt8m.py train.list # 拆分每个train*.pkl变成多个train*_split*.pkl
        python3.7 split_yt8m.py val.list # 拆分每个validate*.pkl变成多个validate*_split*.pkl

        ls pkl_frame/train*_split*.pkl > train.list # 将train*_split*.pkl的路径重新写入train.list
        ls pkl_frame/validate*_split*.pkl > val.list # 将validate*_split*.pkl的路径重新写入val.list
        popd
    elif [ ${model_name} == "SlowFast" ]; then
        # pretrain lite train data
        pushd ./data/k400
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/train_link.list
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/val_link.list
        bash download_k400_train.sh
        bash download_k400_val.sh
        popd
    elif [ ${model_name} == "BMN" ]; then
        # pretrain lite train data
        pushd ./data
        mkdir bmn_data
        cd bmn_data
        wget -nc https://paddlemodels.bj.bcebos.com/video_detection/bmn_feat.tar.gz
        tar -zcvf bmn_feat.tar.gz
        wget -nc https://paddlemodels.bj.bcebos.com/video_detection/activitynet_1.3_annotations.json
        wget -nc https://paddlemodels.bj.bcebos.com/video_detection/activity_net_1_3_new.json
        popd
    else
        echo "Not added into TIPC yet."
    fi
elif [ ${MODE} = "lite_train_whole_infer" ];then
    if [ ${model_name} == "PP-TSM" ]; then
        # pretrain lite train data
        pushd ./data/k400
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/train_link.list
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/val_link.list
        bash download_k400_train.sh
        bash download_k400_val.sh
        popd
        # download pretrained weights
        wget -nc -P ./data https://videotag.bj.bcebos.com/PaddleVideo/PretrainModel/ResNet50_vd_ssld_v2_pretrained.pdparams --no-check-certificate
    elif [ ${model_name} == "PP-TSN" ]; then
        # pretrain lite train data
        # pretrain lite train data
        pushd ./data/k400
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/train_link.list
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/val_link.list
        bash download_k400_train.sh
        bash download_k400_val.sh
        popd
        # download pretrained weights
        wget -nc -P ./data https://videotag.bj.bcebos.com/PaddleVideo/PretrainModel/ResNet50_vd_ssld_v2_pretrained.pdparams --no-check-certificate
    elif [ ${model_name} == "AGCN" ]; then
        # pretrain lite train data
        pushd data/fsd10
        wget -nc https://videotag.bj.bcebos.com/Data/FSD_train_data.npy
        wget -nc https://videotag.bj.bcebos.com/Data/FSD_train_label.npy
        popd
    elif [ ${model_name} == "STGCN" ]; then
        # pretrain lite train data
        pushd data/fsd10
        wget -nc https://videotag.bj.bcebos.com/Data/FSD_train_data.npy
        wget -nc https://videotag.bj.bcebos.com/Data/FSD_train_label.npy
        popd
    elif [ ${model_name} == "TSM" ]; then
        # pretrain lite train data
        pushd ./data/k400
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/train_link.list
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/val_link.list
        bash download_k400_train.sh
        bash download_k400_val.sh
        popd
        # download pretrained weights
        wget -nc -P ./data https://videotag.bj.bcebos.com/PaddleVideo/PretrainModel/ResNet50_vd_ssld_v2_pretrained.pdparams --no-check-certificate
    elif [ ${model_name} == "TSN" ]; then
        # pretrain lite train data
        pushd ./data/k400
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/train_link.list
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/val_link.list
        bash download_k400_train.sh
        bash download_k400_val.sh
        python3.7 extract_rawframes.py ./videos/ ./rawframes/ --level 2 --ext mp4 # extract frames from video file

        # download annotations
        wget https://videotag.bj.bcebos.com/PaddleVideo/Data/Kinetic400/train_frames.list
        wget https://videotag.bj.bcebos.com/PaddleVideo/Data/Kinetic400/val_frames.list
        popd
        # download pretrained weights
        wget -nc -P ./data https://videotag.bj.bcebos.com/PaddleVideo/PretrainModel/ResNet50_vd_ssld_v2_pretrained.pdparams --no-check-certificate
    elif [ ${model_name} == "TimeSformer" ]; then
        # pretrain lite train data
        pushd ./data/k400
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/train_link.list
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/val_link.list
        bash download_k400_train.sh
        bash download_k400_val.sh
        popd
        # download pretrained weights
        wget -nc -P ./data https://paddle-imagenet-models-name.bj.bcebos.com/dygraph/ViT_base_patch16_224_pretrained.pdparams --no-check-certificate
    elif [ ${model_name} == "AttentionLSTM" ]; then
        # pretrain lite train data
        pushd data/yt8m
        mkdir frame
        cd frame
        ## download & decompression training data
        curl data.yt8m.org/download.py | partition=2/frame/train mirror=asia python
        curl data.yt8m.org/download.py | partition=2/frame/validate mirror=asia python
        python3.7 -m pip install tensorflow-gpu==1.14.0
        cd ..
        python3.7 tf2pkl.py ./frame ./pkl_frame/
        ls pkl_frame/train*.pkl > train.list # 将train*.pkl的路径写入train.list
        ls pkl_frame/validate*.pkl > val.list # 将validate*.pkl的路径写入val.list

        python3.7 split_yt8m.py train.list # 拆分每个train*.pkl变成多个train*_split*.pkl
        python3.7 split_yt8m.py val.list # 拆分每个validate*.pkl变成多个validate*_split*.pkl

        ls pkl_frame/train*_split*.pkl > train.list # 将train*_split*.pkl的路径重新写入train.list
        ls pkl_frame/validate*_split*.pkl > val.list # 将validate*_split*.pkl的路径重新写入val.list
        popd
    elif [ ${model_name} == "SlowFast" ]; then
        # pretrain lite train data
        pushd ./data/k400
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/train_link.list
        wget -nc https://ai-rank.bj.bcebos.com/Kinetics400/val_link.list
        bash download_k400_train.sh
        bash download_k400_val.sh
        popd
    elif [ ${model_name} == "BMN" ]; then
        # pretrain lite train data
        pushd ./data
        mkdir bmn_data
        cd bmn_data
        wget -nc https://paddlemodels.bj.bcebos.com/video_detection/bmn_feat.tar.gz
        tar -zcvf bmn_feat.tar.gz
        wget -nc https://paddlemodels.bj.bcebos.com/video_detection/activitynet_1.3_annotations.json
        wget -nc https://paddlemodels.bj.bcebos.com/video_detection/activity_net_1_3_new.json
        popd
    else
        echo "Not added into TIPC yet."
    fi
elif [ ${MODE} = "whole_infer" ];then
    if [ ${model_name} = "PP-TSM" ]; then
        # download pretrained weights
        wget -nc -P ./data https://videotag.bj.bcebos.com/PaddleVideo-release2.1/PPTSM/ppTSM_k400_uniform.pdparams --no-check-certificate
    elif [ ${model_name} = "PP-TSN" ]; then
        # download pretrained weights
        wget -nc -P ./data https://videotag.bj.bcebos.com/PaddleVideo-release2.2/ppTSN_k400.pdparams --no-check-certificate
    elif [ ${model_name} == "AGCN" ]; then
        # pretrain lite train data
        pushd data
        wget -nc https://videotag.bj.bcebos.com/PaddleVideo-release2.2/AGCN_fsd.pdparams
        popd
    elif [ ${model_name} == "STGCN" ]; then
        # pretrain lite train data
        pushd data
        wget -nc https://videotag.bj.bcebos.com/PaddleVideo-release2.2/STGCN_fsd.pdparams
        popd
    elif [ ${model_name} == "TSM" ]; then
        # download pretrained weights
        wget -nc -P ./data https://videotag.bj.bcebos.com/PaddleVideo-release2.1/TSM/TSM_k400.pdparams --no-check-certificate
    elif [ ${model_name} == "TSN" ]; then
        # download pretrained weights
        wget -nc -P ./data https://videotag.bj.bcebos.com/PaddleVideo-release2.2/TSN_k400.pdparams --no-check-certificate
    elif [ ${model_name} == "TimeSformer" ]; then
        # download pretrained weights
        wget -nc -P ./data https://videotag.bj.bcebos.com/PaddleVideo-release2.2/TimeSformer_k400.pdparams --no-check-certificate
    elif [ ${model_name} == "AttentionLSTM" ]; then
        # download pretrained weights
        wget -nc -P ./data https://videotag.bj.bcebos.com/PaddleVideo-release2.2/AttentionLSTM_yt8.pdparams --no-check-certificate
    elif [ ${model_name} == "SlowFast" ]; then
        # download pretrained weights
        wget -nc -P ./data https://videotag.bj.bcebos.com/PaddleVideo/SlowFast/SlowFast.pdparams --no-check-certificate
    elif [ ${model_name} == "BMN" ]; then
        # download pretrained weights
        wget -nc -P ./data https://videotag.bj.bcebos.com/PaddleVideo/BMN/BMN.pdparams --no-check-certificate
    else
        echo "Not added into TIPC yet."
    fi
fi

if [ ${MODE} = "klquant_whole_infer" ]; then
    echo "Not added into TIPC now."
fi

if [ ${MODE} = "cpp_infer" ];then
    if [ ${model_name} = "PP-TSM" ]; then
        wget -nc -P data/ https://videotag.bj.bcebos.com/PaddleVideo-release2.1/PPTSM/ppTSM_k400_uniform.pdparams
    elif [ ${model_name} = "PP-TSN" ]; then
        wget -nc -P data/ https://videotag.bj.bcebos.com/PaddleVideo-release2.2/ppTSN_k400.pdparams
    else
        echo "Not added into TIPC now."
    fi
fi

if [ ${MODE} = "serving_infer" ];then
    echo "Not added into TIPC now."
fi

if [ ${MODE} = "paddle2onnx_infer" ];then
    echo "Not added into TIPC now."
fi
