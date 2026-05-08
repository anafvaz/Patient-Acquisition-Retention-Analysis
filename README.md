# Patient-Acquisition-Retention-Analysis
Analysis of patient acquisition ROI across five channels for a mental health therapy clinic, identifying which channels deliver the highest lifetime value relative to acquisition cost and where marketing spend should be concentrated.

## Business Problem
Clinics running multiple acquisition channels rarely know which ones actually pay off over time. This analysis answers that question: given what the clinic spends to acquire a patient through each channel, how much revenue does that patient generate before they stop attending?

## Stakeholders
Clinic Operations Director
Marketing Lead

## Data
Synthetic data modelled on realistic clinic operations, covering patients, appointments, payments, and monthly acquisition costs across four years (2022–2025). No real patient data was used. The analytical methodology mirrors real operational work.
Tables: patients, appointments, payments, acquisition_costs, services, therapists

## Key Findings
 - GP Referral and Referral - Patient are the strongest channels by a significant margin, with LTV:CAC ratios of 12.7 and 9.1 respectively — every €1 spent returns €12.7 and €9.1 in patient revenue. Organic Search is marginally viable at 3.1. Paid Social and Corporate Partnership both fall below 1.0, meaning the clinic spends more acquiring these patients than it ever recovers.
 - Patient retention drops steeply across all channels — more than 50% of patients do not return after their third session. This limits revenue across the board regardless of how patients were acquired.

## Recommendations
 - Scale GP Referral and Referral - Patient. Both channels deliver strong returns at low spend. Priority actions: strengthen GP relationships and introduce a structured patient referral programme.
 - Investigate Paid Social and Corporate Partnership before cutting spend - Both return less than €1 per €1 spent, but the root cause is unclear. A deeper analysis by channel is needed to determine whether performance is correctable before deciding to pause or redirect investment.
 - Address early dropout before scaling any channel - Over half of patients do not return past session 3, which limits lifetime revenue regardless of how well acquisition performs. Improving retention in the first four sessions would have a greater impact on overall ROI than optimising any single acquisition channel.

## Tools
SQL · DBeaver · Power BI 

<img width="1322" height="754" alt="Screenshot 2026-05-08 at 8 02 55 AM" src="https://github.com/user-attachments/assets/7fc1fba1-bd09-4680-920d-45234495f2ec" />
