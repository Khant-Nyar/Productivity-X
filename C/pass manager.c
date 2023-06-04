#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/conf.h>
#include <openssl/evp.h>
#include <openssl/err.h>

#define MAX_ACCOUNTS 100
#define MAX_URL_LENGTH 100
#define MAX_USERNAME_LENGTH 50
#define MAX_PASSWORD_LENGTH 50
#define MAX_FILE_NAME_LENGTH 100
#define MAX_KEY_LENGTH 32
#define NONCE_SIZE 12

typedef struct {
    char url[MAX_URL_LENGTH];
    char username[MAX_USERNAME_LENGTH];
    char password[MAX_PASSWORD_LENGTH];
} Account;

Account accounts[MAX_ACCOUNTS];
int numAccounts = 0;

void handleErrors() {
    ERR_print_errors_fp(stderr);
    exit(1);
}

void encryptData(const unsigned char *plaintext, int plaintextLen, const unsigned char *key, const unsigned char *nonce, unsigned char *ciphertext) {
    EVP_CIPHER_CTX *ctx;
    int len;
    int ciphertextLen;

    if (!(ctx = EVP_CIPHER_CTX_new())) {
        handleErrors();
    }

    if (1 != EVP_EncryptInit_ex(ctx, EVP_aes_256_gcm(), NULL, NULL, NULL)) {
        handleErrors();
    }

    if (1 != EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_SET_IVLEN, NONCE_SIZE, NULL)) {
        handleErrors();
    }

    if (1 != EVP_EncryptInit_ex(ctx, NULL, NULL, key, nonce)) {
        handleErrors();
    }

    if (1 != EVP_EncryptUpdate(ctx, ciphertext, &len, plaintext, plaintextLen)) {
        handleErrors();
    }
    ciphertextLen = len;

    if (1 != EVP_EncryptFinal_ex(ctx, ciphertext + len, &len)) {
        handleErrors();
    }
    ciphertextLen += len;

    if (1 != EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_GET_TAG, 16, ciphertext + ciphertextLen)) {
        handleErrors();
    }

    EVP_CIPHER_CTX_free(ctx);
}

void decryptData(const unsigned char *ciphertext, int ciphertextLen, const unsigned char *key, const unsigned char *nonce, unsigned char *plaintext) {
    EVP_CIPHER_CTX *ctx;
    int len;
    int plaintextLen;

    if (!(ctx = EVP_CIPHER_CTX_new())) {
        handleErrors();
    }

    if (1 != EVP_DecryptInit_ex(ctx, EVP_aes_256_gcm(), NULL, NULL, NULL)) {
        handleErrors();
    }

    if (1 != EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_SET_IVLEN, NONCE_SIZE, NULL)) {
        handleErrors();
    }

    if (1 != EVP_DecryptInit_ex(ctx, NULL, NULL, key, nonce)) {
        handleErrors();
    }

    if (1 != EVP_DecryptUpdate(ctx, plaintext, &len, ciphertext, ciphertextLen)) {
        handleErrors();
    }
    plaintextLen = len;

    if (1 != EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_SET_TAG, 16, ciphertext + ciphertextLen)) {
        handleErrors();
    }

    if (1 != EVP_DecryptFinal_ex(ctx, plaintext + len, &len)) {
        handleErrors();
    }
    plaintextLen += len;

    EVP_CIPHER_CTX_free(ctx);
}

void saveAccountsToFile(const char *filename, const char *key) {
    FILE *file;
    unsigned char ciphertext[MAX_ACCOUNTS * (MAX_URL_LENGTH + MAX_USERNAME_LENGTH + MAX_PASSWORD_LENGTH)];
    unsigned char plaintext[MAX_ACCOUNTS * (MAX_URL_LENGTH + MAX_USERNAME_LENGTH + MAX_PASSWORD_LENGTH)];
    unsigned char nonce[NONCE_SIZE];
    int ciphertextLen;
    int plaintextLen;
    int i;

    RAND_bytes(nonce, NONCE_SIZE);

    for (i = 0; i < numAccounts; i++) {
        sprintf((char *)plaintext + i * (MAX_URL_LENGTH + MAX_USERNAME_LENGTH + MAX_PASSWORD_LENGTH), "%s:%s:%s",
                accounts[i].url, accounts[i].username, accounts[i].password);
    }
    plaintextLen = numAccounts * (MAX_URL_LENGTH + MAX_USERNAME_LENGTH + MAX_PASSWORD_LENGTH);

    encryptData(plaintext, plaintextLen, (const unsigned char *)key, nonce, ciphertext);
    ciphertextLen = plaintextLen + 16; // ciphertextLen = plaintextLen + tag length

    file = fopen(filename, "wb");
    if (file == NULL) {
        printf("Failed to open file for writing.\n");
        return;
    }

    fwrite(nonce, 1, NONCE_SIZE, file);
    fwrite(ciphertext, 1, ciphertextLen, file);

    fclose(file);

    printf("Accounts saved to file.\n");
}

void loadAccountsFromFile(const char *filename, const char *key) {
    FILE *file;
    unsigned char ciphertext[MAX_ACCOUNTS * (MAX_URL_LENGTH + MAX_USERNAME_LENGTH + MAX_PASSWORD_LENGTH)];
    unsigned char plaintext[MAX_ACCOUNTS * (MAX_URL_LENGTH + MAX_USERNAME_LENGTH + MAX_PASSWORD_LENGTH)];
    unsigned char nonce[NONCE_SIZE];
    int ciphertextLen;
    int plaintextLen;
    int i;

    file = fopen(filename, "rb");
    if (file == NULL) {
        printf("Failed to open file for reading.\n");
        return;
    }

    fread(nonce, 1, NONCE_SIZE, file);
    ciphertextLen = fread(ciphertext, 1, sizeof(ciphertext), file);

    fclose(file);

    decryptData(ciphertext, ciphertextLen, (const unsigned char *)key, nonce, plaintext);
    plaintextLen = ciphertextLen - 16; // ciphertextLen = plaintextLen + tag length

    numAccounts = plaintextLen / (MAX_URL_LENGTH + MAX_USERNAME_LENGTH + MAX_PASSWORD_LENGTH);

    for (i = 0; i < numAccounts; i++) {
        sscanf((char *)plaintext + i * (MAX_URL_LENGTH + MAX_USERNAME_LENGTH + MAX_PASSWORD_LENGTH), "%[^:]:%[^:]:%s",
                accounts[i].url, accounts[i].username, accounts[i].password);
    }

    printf("Accounts loaded from file.\n");
}

void addAccount(const char *url, const char *username, const char *password) {
    if (numAccounts >= MAX_ACCOUNTS) {
        printf("Cannot add more accounts. Maximum limit reached.\n");
        return;
    }

    if (strlen(url) >= MAX_URL_LENGTH || strlen(username) >= MAX_USERNAME_LENGTH || strlen(password) >= MAX_PASSWORD_LENGTH) {
        printf("Invalid URL, username, or password length.\n");
        return;
    }

    strcpy(accounts[numAccounts].url, url);
    strcpy(accounts[numAccounts].username, username);
    strcpy(accounts[numAccounts].password, password);
    numAccounts++;

    printf("Account added successfully.\n");
}

void displayAccounts() {
    if (numAccounts == 0) {
        printf("No accounts found.\n");
        return;
    }

    printf("Accounts:\n");
    for (int i = 0; i < numAccounts; i++) {
        printf("URL: %s\n", accounts[i].url);
        printf("Username: %s\n", accounts[i].username);
        printf("Password: %s\n", accounts[i].password);
        printf("--------\n");
    }
}

int main() {
    int choice;
    char url[MAX_URL_LENGTH];
    char username[MAX_USERNAME_LENGTH];
    char password[MAX_PASSWORD_LENGTH];
    char filename[MAX_FILE_NAME_LENGTH];
    char key[MAX_KEY_LENGTH];

    printf("Enter the file name to save/load the accounts: ");
    scanf("%s", filename);
    printf("Enter the encryption key (32 bytes): ");
    scanf("%s", key);

    do {
        printf("Password Manager\n");
        printf("1. Add Account\n");
        printf("2. Display Accounts\n");
        printf("3. Save Accounts to File\n");
        printf("4. Load Accounts from File\n");
        printf("5. Exit\n");
        printf("Enter your choice: ");
        scanf("%d", &choice);

        switch (choice) {
            case 1:
                printf("Enter URL: ");
                scanf("%s", url);
                printf("Enter username: ");
                scanf("%s", username);
                printf("Enter password: ");
                scanf("%s", password);
                addAccount(url, username, password);
                break;
            case 2:
                displayAccounts();
                break;
            case 3:
                saveAccountsToFile(filename, key);
                break;
            case 4:
                loadAccountsFromFile(filename, key);
                break;
            case 5:
                printf("Exiting...\n");
                break;
            default:
                printf("Invalid choice. Please try again.\n");
                break;
        }
    } while (choice != 5);

    return 0;
}
