# Vour School Notes - Entity Relationship Diagram

## Database Schema Overview

```
┌─────────────────┐       ┌─────────────────┐
│  departments    │       │     trades      │
├─────────────────┤       ├─────────────────┤
│ id (PK)         │──1:N──│ id (PK)         │
│ name            │       │ department_id   │
│ description     │       │ name            │
│ created_at      │       │ description     │
│ updated_at      │       │ created_at      │
└─────────────────┘       │ updated_at      │
                         └────────┬────────┘
                                  │ 1:N
                         ┌────────▼────────┐
                         │    levels       │
                         ├─────────────────┤
                         │ id (PK)         │
                         │ trade_id (FK)   │
                         │ name            │
                         │ description     │
                         │ created_at      │
                         │ updated_at      │
                         └────────┬────────┘
                                  │
        ┌─────────────────────────┼─────────────────────────┐
        │                         │                         │
        │                     ┌───▼────────┐                │
        │                     │   users    │                │
        │                     ├─────────────┤                │
        │                     │ id (PK)    │                │
        │                     │ name       │                │
        │                     │ email      │                │
        │                     │ password   │                │
        │                     │ phone      │                │
        │                     │ role       │◄───────────────┤
        │                     │ department_id (FK)         │
        │                     │ trade_id (FK)  │           │
        │                     │ level_id (FK)  │           │
        │                     │ is_approved    │           │
        │                     │ is_active     │           │
        │                     │ created_at    │           │
        │                     │ updated_at    │           │
        │                     └───────┬───────┘           │
        │                             │ 1:N                │
        │                     ┌───────▼───────┐           │
        │                     │   subjects    │           │
        │                     ├───────────────┤           │
        │                     │ id (PK)       │           │
        │                     │ name          │           │
        │                     │ description   │           │
        │─────────────────────│ teacher_id (FK)           │
        │                     │ trade_id (FK)  │           │
        │                     │ level_id (FK)  │           │
        │                     │ created_at    │           │
        │                     │ updated_at    │           │
        │                     └───────┬───────┘           │
        │                             │ 1:N                │
        │                     ┌───────▼───────┐           │
        │                     │    notes      │           │
        │                     ├───────────────┤           │
        │                     │ id (PK)       │           │
        │                     │ title         │           │
        │                     │ description   │           │
        │                     │ file_name     │           │
        │                     │ file_path     │           │
        │                     │ file_type     │           │
        │                     │ file_size     │           │
        │                     │ subject_id (FK)            │
        │                     │ teacher_id (FK)           │
        │                     │ download_count            │
        │                     │ is_published              │
        │                     │ created_at                │
        │                     │ updated_at                │
        │                     └───────────────────────────┘
        │
        └─ OR ─┐
               │
               └── subjects ─── notes (directly via trade_id, level_id)
```

## Relationship Summary

| From Entity | To Entity | Relationship Type | Description |
|-------------|-----------|------------------|-------------|
| departments | trades | 1:N | One department has many trades |
| trades | levels | 1:N | One trade has many levels |
| departments | users | 1:N | One department has many users |
| trades | users | 1:N | One trade has many users |
| levels | users | 1:N | One level has many users |
| users | subjects | 1:N | One teacher teaches many subjects |
| trades | subjects | 1:N | One trade has many subjects |
| levels | subjects | 1:N | One level has many subjects |
| subjects | notes | 1:N | One subject has many notes |
| users | notes | 1:N | One teacher uploads many notes |

## Table Indexes

- **departments**: Primary Key (id), Unique (name)
- **trades**: Primary Key (id), Foreign Key (department_id), Unique (department_id, name)
- **levels**: Primary Key (id), Foreign Key (trade_id), Unique (trade_id, name)
- **users**: Primary Key (id), Unique (email), Foreign Keys (department_id, trade_id, level_id)
- **subjects**: Primary Key (id), Foreign Keys (teacher_id, trade_id, level_id), Unique (teacher_id, trade_id, level_id, name)
- **notes**: Primary Key (id), Foreign Keys (subject_id, teacher_id)

## Views Created

1. **v_teachers** - Teachers with department/trade/level info
2. **v_students** - Students with department/trade/level info  
3. **v_notes** - Notes with full details (subject, teacher, department, trade, level)
4. **v_subjects** - Subjects with teacher and trade/level info

## Stored Procedures

1. **sp_get_notes_by_student** - Get notes filtered by department/trade/level
2. **sp_get_teacher_subjects** - Get subjects assigned to a teacher
3. **sp_register_student** - Register new student
4. **sp_register_teacher** - Register new teacher
5. **sp_upload_note** - Upload a new note
6. **sp_approve_student** - Approve student registration
