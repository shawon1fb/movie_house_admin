// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../../data/gallery_options.dart';
import '../../../layout/adaptive.dart';
import '../../../layout/text_scale.dart';
import '../components/tabbar/app_tab_bar.dart';
import '../components/tabbar/tab.view.dart';

const int tabCount = 5;
const int turnsToRotateRight = 1;
const int turnsToRotateLeft = 3;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin, RestorationMixin {
  late TabController _tabController;
  RestorableInt tabIndex = RestorableInt(0);

  @override
  String get restorationId => 'home_page';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabCount, vsync: this)
      ..addListener(() {
        // Set state to make sure that the [_RallyTab] widgets get updated when changing tabs.
        setState(() {
          tabIndex.value = _tabController.index;
        });
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = isDisplayDesktop(context);
    Widget tabBarView;
    if (isDesktop) {
      final isTextDirectionRtl =
          GalleryOptions.of(context).resolvedTextDirection() == TextDirection.rtl;
      final verticalRotation = isTextDirectionRtl ? turnsToRotateLeft : turnsToRotateRight;
      final revertVerticalRotation = isTextDirectionRtl ? turnsToRotateRight : turnsToRotateLeft;
      tabBarView = Row(
        children: [
          Container(
            width: 150 + 50 * (cappedTextScale(context) - 1),
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              children: [
                const SizedBox(height: 24),
                ExcludeSemantics(
                  child: SizedBox(
                    height: 80,
                    child: Image.asset(
                      'logo.png',
                      package: 'rally_assets',
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Rotate the tab bar, so the animation is vertical for desktops.
                RotatedBox(
                  quarterTurns: verticalRotation,
                  child: RallyTabBar(
                    tabs: _buildTabs(context: context, theme: theme, isVertical: true).map(
                      (widget) {
                        // Revert the rotation on the tabs.
                        return RotatedBox(
                          quarterTurns: revertVerticalRotation,
                          child: widget,
                        );
                      },
                    ).toList(),
                    tabController: _tabController,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            // Rotate the tab views so we can swipe up and down.
            child: RotatedBox(
              quarterTurns: verticalRotation,
              child: TabBarView(
                controller: _tabController,
                children: _buildTabViews().map(
                  (widget) {
                    // Revert the rotation on the tab views.
                    return RotatedBox(
                      quarterTurns: revertVerticalRotation,
                      child: widget,
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ],
      );
    } else {
      tabBarView = Column(
        children: [
          RallyTabBar(
            tabs: _buildTabs(context: context, theme: theme),
            tabController: _tabController,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _buildTabViews(),
            ),
          ),
        ],
      );
    }

    return ApplyTextOptions(
      child: Scaffold(
        body: SafeArea(
          // For desktop layout we do not want to have SafeArea at the top and
          // bottom to display 100% height content on the accounts view.
          top: !isDesktop,
          bottom: !isDesktop,
          child: Theme(
            // This theme effectively removes the default visual touch
            // feedback for tapping a tab, which is replaced with a custom
            // animation.
            data: theme.copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: tabBarView,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTabs(
      {required BuildContext context, required ThemeData theme, bool isVertical = false}) {
    return [
      RallyTab(
        theme: theme,
        iconData: Icons.pie_chart,
        title: "Overview".toUpperCase(),
        tabIndex: 0,
        tabController: _tabController,
        isVertical: isVertical,
      ),
      RallyTab(
        theme: theme,
        iconData: Icons.attach_money,
        title: "Accounts".toUpperCase(),
        tabIndex: 1,
        tabController: _tabController,
        isVertical: isVertical,
      ),
      RallyTab(
        theme: theme,
        iconData: Icons.money_off,
        title: "Bills".toUpperCase(),
        tabIndex: 2,
        tabController: _tabController,
        isVertical: isVertical,
      ),
      RallyTab(
        theme: theme,
        iconData: Icons.table_chart,
        title: "Budgets".toUpperCase(),
        tabIndex: 3,
        tabController: _tabController,
        isVertical: isVertical,
      ),
      RallyTab(
        theme: theme,
        iconData: Icons.settings,
        title: "Settings".toUpperCase(),
        tabIndex: 4,
        tabController: _tabController,
        isVertical: isVertical,
      ),
    ];
  }

  List<Widget> _buildTabViews() {
    return [
      Container(),
      Container(),
      Container(),
      Container(),
      Container(),
    ];
  }
}
