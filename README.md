# AI Voice Agent for Hospital Appointment Scheduling

![Python](https://img.shields.io/badge/Python-3.10+-blue.svg)
![FastAPI](https://img.shields.io/badge/FastAPI-0.100+-009688.svg)
![SQLite](https://img.shields.io/badge/SQLite-Database-003B57.svg)
![Vapi](https://img.shields.io/badge/Vapi-Voice_AI-FF4B4B.svg)

An end-to-end, fully autonomous AI voice agent designed to handle inbound patient calls for a clinic or hospital. Instead of relying on a human receptionist or a static IVR, this system uses natural language processing to converse with patients, parse their intent, and directly execute read/write operations on a backend database to manage appointments.

## System Architecture

The project is structured into three decoupled phases, ensuring a clean separation of concerns between the conversational AI frontend and the data management backend.
## Core Logic & Components

### 1. Vapi AI Setup (Phase 1)
The conversational interface is powered by Vapi and configured with a custom system prompt to adopt the persona of a professional medical receptionist. The agent is equipped with "Tools" (API requests) that it autonomously decides to trigger based on the context of the conversation.
* **Data Contracts:** Each tool enforces strict data contracts (e.g., extracting date, patient name, and reason) before firing the request.

### 2. FastAPI Backend & SQLite Database (Phase 2)
A highly concurrent Python backend built with FastAPI. It uses SQLAlchemy as an ORM to interact with a lightweight SQLite database.
* **Endpoints:** Maps directly to the AI's tools (e.g., `/schedule`, `/cancel`, `/availability`).
* **Pydantic Models:** Enforces strict request and response validation, ensuring the AI agent only passes clean, correctly formatted data to the database.

### 3. Webhook Integration (Phase 3)
The Vapi agent tools are linked to the local FastAPI server using ngrok for secure tunneling. This allows the cloud-based LLM to seamlessly execute local backend functions in real-time while the patient is on the phone.

---

## Tech Stack
* **Language:** Python
* **Backend Framework:** FastAPI, Uvicorn
* **Database & ORM:** SQLite, SQLAlchemy
* **Data Validation:** Pydantic
* **AI Voice Platform:** Vapi
* **Environment Management:** `uv`
* **Local Testing UI:** Streamlit
* **Network Tunneling:** ngrok

---


```mermaid
graph LR
    Patient((Patient)) <-->|Voice Interaction| VAPI{VAPI AI Agent}

    subgraph Phase 1: Conversational Frontend
        VAPI <--> T1[Availability Tool]
        VAPI <--> T2[Book Appointment Tool]
        VAPI <--> T3[Check Appointment Tool]
        VAPI <--> T4[Cancel Appointment Tool]
    end

    subgraph Phase 3: Integration
        T1 -.->|API Payload| E1
        T2 -.->|API Payload| E2
        T3 -.->|API Payload| E3
        T4 -.->|API Payload| E4
    end

    subgraph Phase 2: API Backend & Database
        E1[Availability Endpoint]
        E2[Schedule Endpoint]
        E3[Appointment Endpoint]
        E4[Cancel Endpoint]

        Backend[FastAPI Backend Logic]
        DB[(SQLite Database)]

        E1 & E2 & E3 & E4 <--> Backend
        Backend <-->|Read / Write via ORM| DB
    end
    
    classDef frontend fill:#ff9999,stroke:#333,stroke-width:2px;
    classDef backend fill:#b3b3ff,stroke:#333,stroke-width:2px;
    classDef db fill:#99ff99,stroke:#333,stroke-width:2px;
    
    class T1,T2,T3,T4 frontend;
    class E1,E2,E3,E4,Backend backend;
    class DB db;

