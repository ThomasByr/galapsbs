import 'package:flutter/material.dart';

import 'image_card_content.dart';

class TransparentImageCard extends StatefulWidget {
  const TransparentImageCard({
    Key? key,
    this.width,
    this.height,
    this.contentMarginTop,
    this.borderRadius = 6,
    this.contentPadding,
    required this.imageProvider,
    this.tags,
    this.title,
    this.description,
    this.footer,
    this.startColor,
    this.endColor,
    this.tagSpacing,
    this.tagRunSpacing,
  }) : super(key: key);

  State<TransparentImageCard> createState() => _TransparentImageCardState();

  /// card width
  final double? width;

  /// card height
  final double? height;

  /// padding from top of card to content
  final double? contentMarginTop;

  /// border radius value
  final double borderRadius;

  /// spacing between tag
  final double? tagSpacing;

  /// run spacing between line tag
  final double? tagRunSpacing;

  /// content padding
  final EdgeInsetsGeometry? contentPadding;

  /// image provider
  final ImageProvider imageProvider;

  /// list of widgets
  final List<Widget>? tags;

  /// color gradient start, default [0xff575757] with opacity 0
  final Color? startColor;

  /// color gradient end, default [0xff000000]
  final Color? endColor;

  /// widget title of card
  final Widget? title;

  /// widget description of card
  final Widget? description;

  /// widget footer of card
  final Widget? footer;
}

class _TransparentImageCardState extends State<TransparentImageCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    final Widget content = ImageCardContent(
      contentPadding: widget.contentPadding,
      tags: widget.tags,
      title: widget.title,
      footer: widget.footer,
      description: widget.description,
      tagSpacing: widget.tagSpacing,
      tagRunSpacing: widget.tagRunSpacing,
    );

    return _buildBody(content);
  }

  Widget _buildBody(Widget content) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          hover = true;
        });
      },
      onExit: (event) {
        setState(() {
          hover = false;
        });
      },
      onHover: (event) {
        setState(() {});
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: ShaderMask(
              shaderCallback: (bound) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    widget.startColor ?? const Color(0xff575757).withOpacity(0),
                    widget.endColor ?? const Color(0xff000000),
                  ],
                  //tileMode: TileMode.,
                ).createShader(bound);
              },
              blendMode: BlendMode.srcOver,
              child: Container(
                width: widget.width,
                height: widget.height,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  transform: Matrix4.identity()
                    ..scale(hover ? 1.05 : 1.0)
                    ..translate(
                      hover ? -widget.width! * 0.025 : 0,
                      hover ? -widget.height! * 0.025 : 0,
                    ),
                  child: Image(
                    image: widget.imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: Colors.transparent,
            ),
            padding: EdgeInsets.only(top: widget.contentMarginTop ?? 100),
            child: content,
          ),
        ],
      ),
    );
  }
}
