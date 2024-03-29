//
//  TeamMemberView.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/11.
//

import SwiftUI
import UniformTypeIdentifiers

struct TeamMemberView: View {
    @ObservedObject var labelingRecordListManager:LabelingRecordListManager
    @ObservedObject var teamDataManager: TeamDataManager
    @ObservedObject var videoPlayerManager:VideoPlayerManager
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack{
                TabView(selection: .constant(teamDataManager.getSelectedTab()),
                        content:{
                    PlayerView(
                        teamType: .leftTeam,
                        labelingRecordListManager: labelingRecordListManager,
                        teamDataManager: teamDataManager,
                        videoPlayerManager: videoPlayerManager
                    )
                    .tabItem {}
                    .tag(0)
                    RegisterTeamView(
                        teamDataManager: teamDataManager
                    )
                    .tabItem {}
                    .tag(1)
                    PlayerView(
                        teamType: .rightTeam,
                        labelingRecordListManager: labelingRecordListManager,
                        teamDataManager: teamDataManager,
                        videoPlayerManager: videoPlayerManager
                    )
                    .tabItem {}
                    .tag(2)
                })
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .background(secondaryColor)
                VStack{
                    HStack(spacing: 0){
                        teamMemberTabDivider(dividerNumber: 0, teamDataManager: teamDataManager)
                        //左チームタブ
                        Button(role: .none,
                               action: {
                                    labelingRecordListManager.clearTemporaryRecord()
                                    teamDataManager.setSelectedTab(select: 0)
                                    labelingRecordListManager.setTeamOfTemporaryRecord(teamType: .leftTeam)
                                },
                               label:{
                            Text(teamDataManager.getTeamName(teamType: .leftTeam) ?? "")
                                .frame(maxWidth: .infinity, maxHeight:.infinity)
                                .foregroundStyle(handballGoalWhite)
                                .background(teamDataManager.getSelectedTab()==0 ? secondaryColor:primaryColor)
                                .clipShape(.rect(topLeadingRadius: 5,topTrailingRadius: 5))
                        }
                        )
                        .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                        .buttonStyle(.plain)
                        .buttonBorderShape(.roundedRectangle(radius: 0))
                        .background(primaryColor)
                        .frame(width:geometry.size.width/3-12,height:32)
                        teamMemberTabDivider(dividerNumber: 1, teamDataManager: teamDataManager)
                        //チーム登録タブ
                        Button(role: .none, action: {teamDataManager.setSelectedTab(select: 1)},
                               label:{
                            Text("チーム登録")
                                .frame(maxWidth: .infinity, maxHeight:.infinity)
                                .foregroundStyle(handballGoalWhite)
                                .background(teamDataManager.getSelectedTab()==1 ? secondaryColor:primaryColor)
                                .clipShape(.rect(topLeadingRadius: 5,topTrailingRadius: 5))
                        }
                        )
                        .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                        .buttonStyle(.plain)
                        .buttonBorderShape(.roundedRectangle(radius: 0))
                        .background(primaryColor)
                        .frame(width:geometry.size.width/3-12,height:32)
                        teamMemberTabDivider(dividerNumber: 2, teamDataManager: teamDataManager)
                        //右チームタブ
                        Button(role: .none,
                               action: {
                                labelingRecordListManager.clearTemporaryRecord()
                                teamDataManager.setSelectedTab(select: 2)
                            labelingRecordListManager.setTeamOfTemporaryRecord(teamType: .rightTeam)
                                },
                               label:{
                            Text(teamDataManager.getTeamName(teamType: .rightTeam) ?? "")
                                .frame(maxWidth: .infinity, maxHeight:.infinity)
                                .foregroundStyle(handballGoalWhite)
                                .background(teamDataManager.getSelectedTab()==2 ? secondaryColor:primaryColor)
                                .clipShape(.rect(topLeadingRadius: 5,topTrailingRadius: 5))
                        }
                        )
                        .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                        .buttonStyle(.plain)
                        .buttonBorderShape(.roundedRectangle(radius: 0))
                        .background(primaryColor)
                        .frame(width:geometry.size.width/3-12,height:32)
                        teamMemberTabDivider(dividerNumber: 3, teamDataManager: teamDataManager)
                    }
                    .background(primaryColor)
                    .frame(width:geometry.size.width,height:32)
                    Spacer()
                }
            }
        })
    }
}


struct PlayerView: View {
    let teamType: TeamType
    @ObservedObject var labelingRecordListManager:LabelingRecordListManager
    @ObservedObject var teamDataManager: TeamDataManager
    @ObservedObject var videoPlayerManager:VideoPlayerManager
    
    init(teamType: TeamType,labelingRecordListManager:LabelingRecordListManager,teamDataManager: TeamDataManager,videoPlayerManager:VideoPlayerManager) {
        self.teamType = teamType
        self.labelingRecordListManager = labelingRecordListManager
        self.teamDataManager = teamDataManager
        self.videoPlayerManager = videoPlayerManager
    }
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text("\(labelingRecordListManager.temporaryRecord.time ?? "00:00")")
                    .font(.title)
                    .foregroundStyle(handballGoalWhite)
                Spacer()
                Text("\(videoPlayerManager.localvideoPlayer.videoPastTimeString ?? "00:00")")
                    .font(.title)
                    .foregroundStyle(handballGoalWhite)
                Spacer()
            }
            .padding(EdgeInsets(top: 10,
                                leading: 0,
                                bottom: 0,
                                trailing: 0))
            Spacer()
            HStack(spacing:20){
                let results = [
                    Result.getPoint,
                    Result.missShot,
                    Result.intercept,
                    Result.foul
                ]
                ForEach(results, id: \.self) {result in
                    Button(role: .none,
                           action: {
                        labelingRecordListManager.clearTemporaryRecord()
                        labelingRecordListManager.setResultOfTemporaryRecord(result: result)
                        labelingRecordListManager.setTimeOfTemporaryRecord(time: videoPlayerManager.localvideoPlayer.videoPastTimeString)
                        labelingRecordListManager.setTeamOfTemporaryRecord(teamType: teamType)
                        //markerをnoneに設定
                        labelingRecordListManager.handballCourtMarkerType = .none
                        
                    },
                           label: {
                        Text(result.description() ?? "")
                            .bold()
                            .padding()
//                            .frame(width: 100, height: 30)
                            .foregroundColor(labelingRecordListManager.isResult(result: result) ? handballGoalRed:handballGoalWhite)
                            .background(HandballCourtColor)
                            .clipShape(.rect(topLeadingRadius: 10,
                                             bottomLeadingRadius: 10,
                                             bottomTrailingRadius: 10,
                                             topTrailingRadius: 10
                                            ))
                    }).buttonStyle(.plain)
                }
            }
            Spacer()
            Divider().background(thirdColor).padding(EdgeInsets(top: 0, leading: 37, bottom: 0, trailing: 37))
            Spacer()
            let positions = [
                Position.leftWing,
                Position.pivot,
                Position.rightWing,
                Position.leftBack,
                Position.centerBack,
                Position.rightBack
            ]
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0),
            ], spacing: 10) {
                ForEach(positions, id: \.self) {position in
                    PlayerPositionButtom(
                        teamType:teamType,
                        player: nil,
                        position: position,
                        labelingRecordListManager: labelingRecordListManager,
                        teamDataManager: teamDataManager
                    )
                }
            }
            Spacer()
            Divider().background(thirdColor).padding(EdgeInsets(top: 0, leading: 37, bottom: 0, trailing: 37))
            Spacer()
            let playerList = teamDataManager.getPlayerList(teamType: teamType)
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0),
            ], spacing: 10) {
                ForEach(playerList.keys.sorted(), id: \.self) {player in
                    if teamDataManager.isPlayerTrue(teamType: teamType, playerName: player) &&
                        !teamDataManager.playerHavePosition(teamType: teamType, playerName: player){
                        PlayerPositionButtom(
                            teamType:teamType,
                            player:player,
                            position: .nonPosition,
                            labelingRecordListManager: labelingRecordListManager,
                            teamDataManager: teamDataManager
                        )
                    }
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(secondaryColor)
    }
}

struct RegisterTeamView: View {
    @ObservedObject var teamDataManager: TeamDataManager
    
    var body: some View {
        VStack{
            Button {
                teamDataManager.readTeamCsv(teamType: .leftTeam)
                
            } label: {
                Text("チーム登録")
                    .bold()
                    .padding()
                    .frame(width: 100, height: 30)
                    .foregroundColor(handballGoalWhite)
                    .background(HandballCourtColor)
                    .clipShape(.rect(topLeadingRadius: 10,
                                     bottomLeadingRadius: 10,
                                     bottomTrailingRadius: 10,
                                     topTrailingRadius: 10
                                    ))
            }.buttonStyle(.plain)
                .padding(EdgeInsets(top: 20,
                                    leading: 0,
                                    bottom: 0,
                                    trailing: 0))
            Spacer()
            let leftPlayerList = teamDataManager.getPlayerList(teamType: .leftTeam)
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0),
            ], spacing: 10) {
                ForEach(leftPlayerList.keys.sorted(), id: \.self) {player in
                    RegisterPlayerButton(teamDataManager: teamDataManager, teamType: .leftTeam, player: player)
                }
            }
            Spacer()
            Divider().background(thirdColor).padding(EdgeInsets(top: 0, leading: 37, bottom: 0, trailing: 37))
            
            Button {
                teamDataManager.readTeamCsv(teamType: .rightTeam)
            } label: {
                Text("チーム登録")
                    .bold()
                    .padding()
                    .frame(width: 100, height: 30)
                    .foregroundColor(handballGoalWhite)
                    .background(HandballCourtColor)
                    .clipShape(.rect(topLeadingRadius: 10,
                                     bottomLeadingRadius: 10,
                                     bottomTrailingRadius: 10,
                                     topTrailingRadius: 10
                                    ))
            }.buttonStyle(.plain)
                .padding(EdgeInsets(top: 10,
                                    leading: 0,
                                    bottom: 0,
                                    trailing: 0))
            Spacer()
            let rightPlayerList = teamDataManager.getPlayerList(teamType: .rightTeam)
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0),
            ], spacing: 10) {
                ForEach(rightPlayerList.keys.sorted(), id: \.self) {player in
                    RegisterPlayerButton(teamDataManager: teamDataManager, teamType: .rightTeam, player: player)
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(secondaryColor)
    }
}


struct teamMemberTabDivider:View {
    let dividerNumber:Int
    @ObservedObject var teamDataManager:TeamDataManager
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(secondaryColor)
                .frame(width: 9,height: 32)
            Rectangle()
                .fill(primaryColor)
                .frame(width: 9,height: 32)
                .clipShape(.rect(bottomLeadingRadius: teamDataManager.getSelectedTab()==dividerNumber-1 ? 9:0,
                                 bottomTrailingRadius: teamDataManager.getSelectedTab()==dividerNumber ? 9:0)
                )
            if !(dividerNumber==0) && !(dividerNumber==3) && !(dividerNumber==teamDataManager.getSelectedTab()) && !(dividerNumber-1==teamDataManager.getSelectedTab()){
                Rectangle()
                    .fill(secondaryColor)
                    .frame(width: 1.5, height: 16)
            }
        }
    }
}


struct PlayerPositionButtom: View {
    @ObservedObject var labelingRecordListManager:LabelingRecordListManager
    @ObservedObject var teamDataManager:TeamDataManager
    let teamType:TeamType
    //    let title: String?
    let player: String?
    let position: Position
    
    init(teamType:TeamType,
         //         title:String?,
         player:String?,
         position:Position,
         labelingRecordListManager:LabelingRecordListManager,
         teamDataManager:TeamDataManager
    ){
        self.teamType = teamType
        //        self.title = title
        self.player = player
        self.position = position
        self.labelingRecordListManager = labelingRecordListManager
        self.teamDataManager = teamDataManager
    }
    
    var body: some View {
        VStack{
            if let title = position.description(){
                Text(title)
                    .font(.title3)
                    .foregroundStyle(handballGoalWhite)
            }
            let playerName = position == .nonPosition ? player: teamDataManager.getPositionPlayer(teamType: teamType, position: position)
            let fontColor:Color = 
                labelingRecordListManager.isPlayerAssist(player: playerName) ?
                //assistTrue
                labelingRecordListManager.isPlayerAction(player: playerName) ? .green : .yellow
                //assistFalse
                :labelingRecordListManager.isPlayerAction(player: playerName) ? handballGoalRed : handballGoalWhite
            
            RoundedRectangle(cornerRadius: 5)
                .fill(HandballCourtColor)
                .frame(width: 100,height: 30)
                .overlay(
                    Text(playerName ?? "")
                        .font(.title3)
                        .foregroundStyle(fontColor)
                )
                .onDrag({
                    NSItemProvider(object: (playerName ?? "") as NSItemProviderWriting)
                })
                .onDrop(of: [UTType.text],
                        delegate: PositionDragDelegation(teamType: teamType,position: position,teamDataManager: teamDataManager))
                .onTapGesture(count: 2) {
                    labelingRecordListManager.setActionOfTemporaryRecord(action: playerName)
                }
                .onTapGesture {
                    labelingRecordListManager.setAssistOfTemporaryRecord(assist: playerName)
                }
                .onLongPressGesture {
                    //temporaryRecordのassistが一致したらnilに設定する
                    if labelingRecordListManager.isPlayerAssist(player: playerName){
                        labelingRecordListManager.setAssistOfTemporaryRecord(assist: nil)
                    }
                    //temporaryRecordのactionが一致したらnilに設定する
                    if labelingRecordListManager.isPlayerAction(player: playerName){
                        labelingRecordListManager.setActionOfTemporaryRecord(action: nil)
                    }
                }
        }
    }
}

struct RegisterPlayerButton:View {
    @ObservedObject var teamDataManager:TeamDataManager
    let teamType:TeamType
    let player:String
    
    var body: some View {
        ZStack{
            let activePlayer = teamDataManager.isPlayerTrue(teamType: teamType, playerName: player)
            let activeGoalKeeper = teamDataManager.isGoalKeeperTrue(teamType: teamType, goalKeeperName: player)
            let fontColor:Color = activePlayer && activeGoalKeeper ? .green://キーパーかつスタメンなら緑
                                    activePlayer ? tintBlue://スタメンなら青
                                    activeGoalKeeper ? handballGoalRed://キーパーなら赤
                                    handballGoalWhite//どちらでもなければ白
            
            Rectangle()
                .fill(HandballCourtColor)
                .clipShape(
                    .rect(
                        topLeadingRadius: 5,
                        bottomLeadingRadius: 5,
                        bottomTrailingRadius: 5,
                        topTrailingRadius: 5
                    )
                )
            Text(player)
                .font(.title3)
                .foregroundStyle(fontColor)
            Rectangle()
                .fill(.clear)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .contentShape(Rectangle())
                .clipShape(
                    .rect(
                        topLeadingRadius: 5,
                        bottomLeadingRadius: 5,
                        bottomTrailingRadius: 5,
                        topTrailingRadius: 5
                    )
                )
                .onTapGesture(count: 2) {
                    teamDataManager.toggleGoalKeeper(teamType: teamType, goalKeeperName: player)
                }
                .onTapGesture(count:1){
                    teamDataManager.togglePlayer(teamType: teamType, playerName: player)
                }
                
        }
        .frame(width: 90,height: 25)
    }
}
