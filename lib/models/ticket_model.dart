class Ticket {
  final dynamic ticket;
  final dynamic subject;
  final dynamic status;
  final dynamic lastReply;

  Ticket({
    required this.ticket,
    required this.subject,
    required this.status,
    required this.lastReply,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      ticket: json['ticket'],
      subject: json['subject'],
      status: json['status'],
      lastReply: json['lastReply'],
    );
  }
}

class TicketMessage {
  final dynamic id;
  final dynamic ticketId;
  final dynamic adminId;
  final dynamic message;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic adminImage;
  final List<TicketAttachment> attachments;

  TicketMessage({
    required this.id,
    required this.ticketId,
    required this.adminId,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.adminImage,
    required this.attachments,
  });

  factory TicketMessage.fromJson(Map<String, dynamic> json) {
    return TicketMessage(
      id: json['id'],
      ticketId: json['ticket_id'],
      adminId: json['admin_id'],
      message: json['message'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      adminImage: json['adminImage'],
      attachments: (json['attachments'] as List<dynamic>? ?? [])
          .map((attachment) => TicketAttachment.fromJson(attachment))
          .toList(),
    );
  }
}

class TicketAttachment {
  final dynamic id;
  final dynamic ticketMessageId;
  final dynamic image;
  final dynamic driver;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic attachmentPath;
  final dynamic attachmentName;

  TicketAttachment({
    required this.id,
    required this.ticketMessageId,
    required this.image,
    required this.driver,
    required this.createdAt,
    required this.updatedAt,
    required this.attachmentPath,
    required this.attachmentName,
  });

  factory TicketAttachment.fromJson(Map<String, dynamic> json) {
    return TicketAttachment(
      id: json['id'],
      ticketMessageId: json['ticket_message_id'],
      image: json['image'],
      driver: json['driver'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      attachmentPath: json['attachment_path'],
      attachmentName: json['attachment_name'],
    );
  }
}
