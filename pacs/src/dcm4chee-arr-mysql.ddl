
    create table active_part (
        pk bigint not null auto_increment,
        alt_user_id varchar(255),
        net_access_pt_id varchar(255),
        net_access_pt_type integer,
        user_id varchar(255),
        requestor bit,
        user_name varchar(255),
        audit_record_fk bigint,
        role_id_fk bigint,
        primary key (pk)
    ) ENGINE=INNODB;

    create table audit_record (
        pk bigint not null auto_increment,
        iheyr4 bit,
        site_id varchar(255),
        event_action varchar(255),
        event_date_time datetime,
        event_outcome integer,
        receive_date_time datetime,
        source_id varchar(255),
        source_type integer,
        xmldata mediumblob,
        event_type_fk bigint,
        event_id_fk bigint,
        primary key (pk)
    ) ENGINE=INNODB;

    create table code (
        pk bigint not null auto_increment,
        code_designator varchar(255) not null,
        code_meaning varchar(255),
        code_value varchar(255) not null,
        primary key (pk),
        unique (code_value, code_designator)
    ) ENGINE=INNODB;

    create table part_obj (
        pk bigint not null auto_increment,
        data_life_cycle integer,
        obj_id varchar(255),
        obj_id_type_rfc integer,
        name varchar(255),
        obj_role integer,
        obj_sensitivity varchar(255),
        obj_type integer,
        obj_id_type_fk bigint,
        audit_record_fk bigint,
        primary key (pk)
    ) ENGINE=INNODB;

    alter table active_part 
        add index FKC154118C9F9901B4 (role_id_fk), 
        add constraint FKC154118C9F9901B4 
        foreign key (role_id_fk) 
        references code (pk);

    alter table active_part 
        add index FKC154118C327533D4 (audit_record_fk), 
        add constraint FKC154118C327533D4 
        foreign key (audit_record_fk) 
        references audit_record (pk);

    create index ar_receive_date_ti on audit_record (receive_date_time);

    create index ar_event_date_time on audit_record (event_date_time);

    alter table audit_record 
        add index FKAF55D13517670399 (event_type_fk), 
        add constraint FKAF55D13517670399 
        foreign key (event_type_fk) 
        references code (pk);

    alter table audit_record 
        add index FKAF55D1354D8CC8D8 (event_id_fk), 
        add constraint FKAF55D1354D8CC8D8 
        foreign key (event_id_fk) 
        references code (pk);

    alter table part_obj 
        add index FK46D80EAB57A24562 (obj_id_type_fk), 
        add constraint FK46D80EAB57A24562 
        foreign key (obj_id_type_fk) 
        references code (pk);

    alter table part_obj 
        add index FK46D80EAB327533D4 (audit_record_fk), 
        add constraint FK46D80EAB327533D4 
        foreign key (audit_record_fk) 
        references audit_record (pk);
