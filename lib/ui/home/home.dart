import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_know/commons/colors.dart';
import 'package:internet_know/commons/constants.dart';
import 'package:internet_know/ui/details/detail.dart';
import 'package:internet_know/widgets/all_sections_layout.dart';
import 'package:internet_know/widgets/app_bar_delegate.dart';
import 'package:internet_know/widgets/section_card.dart';
import 'package:internet_know/widgets/section_detail.dart';
import 'package:internet_know/widgets/sections.dart';
import 'package:internet_know/widgets/snapping_scroll_physics.dart';
import 'package:internet_know/widgets/statusbar_padding_sliver.dart';

class AnimationHome extends StatefulWidget {
  const AnimationHome({Key? key}) : super(key: key);

  @override
  State<AnimationHome> createState() => _AnimationHomeState();
}

class _AnimationHomeState extends State<AnimationHome> {
  final divider = const Divider(
    color: Colors.black,
    height: 20,
    thickness: 2,
    indent: 20,
    endIndent: 20,
  );
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final scrollController = ScrollController();
  final headingPageController = PageController();
  final detailsPageController = PageController();
  ScrollPhysics headingScrollPhysics = const NeverScrollableScrollPhysics();
  ValueNotifier<double> selectedIndex = ValueNotifier<double>(0.0);
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: kAppBackgroundColor,
        drawer: drawer(),
        body: Builder(
          builder: buildBody,
        ),
      ),
    );
  }

  Drawer drawer() {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              width: 400,
              height: 170,
              decoration:
                  const BoxDecoration(shape: BoxShape.rectangle, boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                  spreadRadius: 5.0,
                  offset: Offset(0.0, 10.0), // shadow direction: bottom right
                )
              ]),
              child: Image.asset(
                'assets/image/logo.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          divider,
          ListTile(
            leading: const Icon(
              Icons.settings_input_antenna,
              color: Colors.white,
            ),
            title: const Text(
              'Your Location',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            onTap: () {
              setState(() {
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => Detail(
                          imagetype: "lost",
                          url: 'https://www.google.com/android/find?u=0',
                        )));
              });
            },
          ),
          divider,
          ListTile(
            leading: const Icon(
              Icons.assignment,
              color: Colors.white,
            ),
            title: const Text(
              'Live Tracking',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            onTap: () {
              setState(() {
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => Detail(
                          imagetype: "click",
                          url: 'https://clickclickclick.click',
                        )));
              });
            },
          ),
          divider,
          const Expanded(
            child: ListTile(
              leading: Icon(
                Icons.share,
                color: Colors.white,
              ),
              title: Text(
                'Share App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 55.0),
          )
        ],
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double statusBarHeight = mediaQuery.padding.top;
    final double screenHeight = mediaQuery.size.height;
    final double appBarMaxHeight = screenHeight - statusBarHeight;
    final double appBarMidScrollOffset =
        statusBarHeight + appBarMaxHeight - kAppBarMidHeight;
    return SizedBox.expand(
      child: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              return handleScrollNotification(
                  notification, appBarMidScrollOffset);
            },
            child: CustomScrollView(
              controller: scrollController,
              physics:
                  SnappingScrollPhysics(midScrollOffset: appBarMidScrollOffset),
              slivers: [
                StatusBarPaddingSliver(
                  maxHeight: statusBarHeight,
                  scrollFactor: 7.0,
                ),
                SliverPersistentHeader(
                  delegate: SliverAppBarDelegate(
                      minHeight: kAppBarMinHeight,
                      maxHeight: appBarMaxHeight,
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification notification) {
                          return _handlePageNotification(notification,
                              headingPageController, detailsPageController);
                        },
                        child: PageView(
                          physics: headingScrollPhysics,
                          controller: headingPageController,
                          children: allHeadingItems(
                              appBarMaxHeight, appBarMidScrollOffset),
                        ),
                      )),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 610.0,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification notification) {
                        return _handlePageNotification(notification,
                            detailsPageController, headingPageController);
                      },
                      child: PageView(
                        controller: detailsPageController,
                        children: allSections.map((Section section) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: _detailItemsFor(section).toList(),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: statusBarHeight,
            left: 0.0,
            child: IconTheme(
              data: const IconThemeData(color: Colors.white),
              child: SafeArea(
                top: false,
                bottom: false,
                child: IconButton(
                  tooltip: 'menu',
                  onPressed: () {
                    handleBackButton(appBarMidScrollOffset);
                  },
                  icon: const Icon(Icons.menu),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void handleBackButton(double midScrollOffset) {
    // if (_scrollController.offset >= midScrollOffset)
    //   _scrollController.animateTo(0.0, curve: _kScrollCurve, duration: _kScrollDuration);
    // else
    scaffoldKey.currentState!.openDrawer();
  }

  Iterable<Widget> _detailItemsFor(Section section) {
    final Iterable<Widget> detailItems =
        section.details.map((SectionDetail detail) {
      return SectionDetailView(detail: detail);
    });
    return ListTile.divideTiles(context: context, tiles: detailItems);
  }

  List<Widget> allHeadingItems(double maxHeight, double midScrollOffset) {
    final List<Widget> sectionCards = <Widget>[];
    for (int index = 0; index < allSections.length; index++) {
      sectionCards.add(LayoutId(
        id: 'card$index',
        child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: SectionCard(section: allSections[index]),
            onTapUp: (TapUpDetails details) {
              final double xOffset = details.globalPosition.dx;
              setState(() {
                _maybeScroll(midScrollOffset, index, xOffset);
              });
            }),
      ));
    }

    final List<Widget> headings = <Widget>[];
    for (int index = 0; index < allSections.length; index++) {
      headings.add(Container(
        color: kAppBackgroundColor,
        child: ClipRect(
          child: AllSectionsView(
            sectionIndex: index,
            sections: allSections,
            selectedIndex: selectedIndex,
            minHeight: kAppBarMinHeight,
            midHeight: kAppBarMidHeight,
            maxHeight: maxHeight,
            sectionCards: sectionCards,
          ),
        ),
      ));
    }
    return headings;
  }

  void _maybeScroll(double midScrollOffset, int pageIndex, double xOffset) {
    if (scrollController.offset < midScrollOffset) {
      // Scroll the overall list to the point where only one section card shows.
      // At the same time scroll the PageViews to the page at pageIndex.
      headingPageController.animateToPage(pageIndex,
          curve: kScrollCurve, duration: kScrollDuration);
      scrollController.animateTo(midScrollOffset,
          curve: kScrollCurve, duration: kScrollDuration);
    } else {
      // One one section card is showing: scroll one page forward or back.
      final double centerX =
          headingPageController.position.viewportDimension / 2.0;
      final int pageindex = xOffset > centerX ? pageIndex + 1 : pageIndex - 1;
      headingPageController.animateToPage(pageindex,
          curve: kScrollCurve, duration: kScrollDuration);
    }
  }

  bool _handlePageNotification(ScrollNotification notification,
      PageController leader, PageController follower) {
    if (notification.depth == 0 && notification is ScrollUpdateNotification) {
      selectedIndex.value = leader.page!;
      if (follower.page != leader.page) {
        follower.position.jumpTo(leader.position.pixels);
      } // ignore: deprecated_member_use
    }
    return false;
  }

  bool handleScrollNotification(
      ScrollNotification notification, double midScrollOffset) {
    if (notification.depth == 0 && notification is ScrollUpdateNotification) {
      final ScrollPhysics physics =
          scrollController.position.pixels >= midScrollOffset
              ? const PageScrollPhysics()
              : const NeverScrollableScrollPhysics();
      if (physics != headingScrollPhysics) {
        setState(() {
          headingScrollPhysics = physics;
        });
      }
    }
    return false;
  }

  Future<bool> onWillPop() {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double statusBarHeight = mediaQuery.padding.top;
    final double screenHeight = mediaQuery.size.height;
    final double appBarMaxHeight = screenHeight - statusBarHeight;
    final double appBarMidScrollOffset =
        statusBarHeight + appBarMaxHeight - kAppBarMidHeight;
    if (scrollController.offset >= appBarMidScrollOffset) {
      scrollController.animateTo(0.0,
          duration: kScrollDuration, curve: kScrollCurve);
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
