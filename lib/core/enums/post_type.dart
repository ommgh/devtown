enum PostType {
  text('text'),
  image('image');

  final String type;
  const PostType(this.type);
}

extension ConvertPost on String {
  PostType toPostTypeEnum() {
    switch (this) {
      case 'text':
        return PostType.text;
      case 'image':
        return PostType.image;
      default:
        return PostType.text;
    }
  }
}
