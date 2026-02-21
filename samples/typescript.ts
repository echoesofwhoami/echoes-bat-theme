// TypeScript sample file for testing syntax highlighting
interface User {
    id: number;
    name: string;
    email?: string;
    roles: Role[];
}

enum Role {
    ADMIN = 'admin',
    USER = 'user',
    MODERATOR = 'moderator'
}

class UserService {
    private users: Map<number, User> = new Map();

    constructor(private apiClient: ApiClient) {}

    async createUser(userData: Omit<User, 'id'>): Promise<User> {
        try {
            const response = await this.apiClient.post('/users', userData);
            const user: User = {
                id: response.data.id,
                ...userData
            };
            this.users.set(user.id, user);
            return user;
        } catch (error) {
            console.error('Failed to create user:', error);
            throw new Error('User creation failed');
        }
    }

    getUserById(id: number): User | undefined {
        return this.users.get(id);
    }

    getUsersByRole(role: Role): User[] {
        return Array.from(this.users.values())
            .filter(user => user.roles.includes(role));
    }
}

type ApiResponse<T> = {
    data: T;
    status: number;
    message: string;
};

// Generic function example
function fetchWithRetry<T>(
    url: string,
    options: RequestInit = {},
    retries: number = 3
): Promise<ApiResponse<T>> {
    return new Promise((resolve, reject) => {
        const attempt = async (attemptCount: number) => {
            try {
                const response = await fetch(url, options);
                if (!response.ok) {
                    throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                }
                const data = await response.json();
                resolve({
                    data,
                    status: response.status,
                    message: 'Success'
                });
            } catch (error) {
                if (attemptCount <= 1) {
                    reject(error);
                } else {
                    console.warn(`Attempt ${4 - attemptCount} failed, retrying...`);
                    setTimeout(() => attempt(attemptCount - 1), 1000);
                }
            }
        };
        attempt(retries);
    });
}

// Decorator example
function log(target: any, propertyName: string, descriptor: PropertyDescriptor) {
    const method = descriptor.value;
    descriptor.value = function (...args: any[]) {
        console.log(`Calling ${propertyName} with:`, args);
        const result = method.apply(this, args);
        console.log(`${propertyName} returned:`, result);
        return result;
    };
}

export { User, Role, UserService, fetchWithRetry, log };
