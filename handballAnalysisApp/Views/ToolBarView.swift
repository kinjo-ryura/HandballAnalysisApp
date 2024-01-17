//
//  ToolBar.swift
//  handballAnalysisApp
//
//  Created by 金城瑠羅 on 2024/01/10.
//

import SwiftUI




struct toolBar: View{
    @ObservedObject var windowDelegate: WindowDelegate
    @ObservedObject var TabListManager: TabListManager
    @Binding var toolBarStatus: Bool
    let geometry: GeometryProxy
    @State var plusIsHovering: Bool = false
    
    var body: some View{
        ZStack{
            if windowDelegate.isFullScreen{
                Rectangle()
                    .fill(primaryColor)
                    .frame(width: toolBarStatus ? geometry.size.width:geometry.size.width+70,height: 40)
                    .padding(EdgeInsets(top: 0, leading: -80, bottom: 0, trailing:-8))
                
            }else{
                Rectangle()
                    .fill(primaryColor)
                    .frame(width: toolBarStatus ? geometry.size.width:geometry.size.width)
                    .padding(EdgeInsets(top: 0, leading: -80, bottom: 0, trailing:-8))
                
            }
            HStack(spacing: 0){
                toolBarDivder(id: nil, TabListManager:_TabListManager)
                ForEach(Array(TabListManager.TabDataList.indices), id: \.self) { index in
                    toolBarTab(id: TabListManager.TabDataList[index].id)
                        .frame(maxWidth: 180)
                    toolBarDivder(id: TabListManager.TabDataList[index].id, TabListManager:_TabListManager)
                }
                ZStack{
                    Rectangle()
                        .fill(plusIsHovering ? plusHoverColor:.clear)
                        .frame(width: 25)
                        .clipShape(Circle())
                    Image(systemName: "plus")
                        .font(Font.title.weight(.light))
                        .foregroundColor(.white)
                        .frame(width: 10)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 25)
                        .clipShape(Circle())
                        .onHover { hovering in
                            plusIsHovering = hovering
                        }
                        .onTapGesture {
                            let tabTypeManager = TabViewDataManager(tabType: TabViewType())
                            let id = UUID()
                            let newTab = MainView(
                                id:id,
                                title: "新規タブ",
                                tabViewType: .newTabView,
                                tabViewDataManager: tabTypeManager,
                                labelingRecordListManager: LabelingRecordListManager(id:id),
                                teamDataManager: TeamDataManager(id:id),
                                videoPlayerManaer: VideoPlayerManager(id:id)
                            )
                            TabListManager.addTabData(tabData: newTab)
                        }
                }
                Spacer()
            }
        }
    }
}



struct toolBarDivder: View {
    let id: UUID?
    @ObservedObject var TabListManager: TabListManager
    
    init(id: UUID?, TabListManager: ObservedObject<TabListManager>) {
        self.id = id
        self._TabListManager = TabListManager
    }
    
    var body: some View {
        ZStack{
            Rectangle().fill(secondaryColor).frame(width: 10)
            Rectangle().fill(primaryColor).frame(width: 10)
                .clipShape(.rect(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: TabListManager.isSelectedTab(id: id) ? 7:0,
                    bottomTrailingRadius: TabListManager.isNextSelectedTab(id: id) ? 7:0,
                    topTrailingRadius: 0
                ))

            //最初のdividerだけは常に表示しない
            if let id{
                //タブと次のタブが選択されていない時だけ表示する
                if !TabListManager.isSelectedTab(id: id) && !TabListManager.isNextSelectedTab(id: id){
                    Rectangle()
                        .fill(secondaryColor)
                        .frame(width: 1.5, height: 16)
                }
            }
        }
    }
}

struct toolBarTab: View {
    let id: UUID
    @EnvironmentObject var TabListManager:TabListManager
    @State var ishovering: Bool = false
    @State var xmarkIshovering: Bool = false
    
    
    
    init(id: UUID) {
        self.id = id
    }
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(TabListManager.isSelectedTab(id: id) ? secondaryColor:primaryColor)
            //                .frame(width: 180,height: 33)
                .frame(height: 33)
                .clipShape(.rect(
                    topLeadingRadius: 7,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 7
                ))
                .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
            HStack{
                Image(systemName: TabListManager.getContentTabViewType(id: id).getTabIcon())
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                Text(TabListManager.getContentTitle(id: id))
                Spacer()
                ZStack{
                    Rectangle()
                        .fill(xmarkIshovering ? xmarkHoverColor:.clear)
                        .frame(width: 16)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    Image(systemName: "xmark")
                        .font(Font.title.weight(.light))
                        .frame(width: 10)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    Rectangle()
                        .fill(.clear)
                        .frame(width: 16)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .onHover(perform: { hovering in
                            xmarkIshovering = hovering
                        })
                        .onTapGesture {
                            TabListManager.removeTabData(id: id)
                        }
                }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .foregroundStyle(.white)
            //            .frame(width: 180,height: 28)
            .frame(maxWidth: .infinity,maxHeight:28)
            .background(TabListManager.isSelectedTab(id: id) ? secondaryColor:
                            ishovering ? hoverColor:primaryColor
            )
            .clipShape(.rect(
                topLeadingRadius: 7,
                bottomLeadingRadius: 7,
                bottomTrailingRadius: 7,
                topTrailingRadius: 7
            ))
            .onHover(perform: { hovering in
                ishovering = hovering
            })
            .onTapGesture {
                TabListManager.setSelectedTab(id: id)
            }
        }.frame(maxWidth: .infinity)
    }
}

